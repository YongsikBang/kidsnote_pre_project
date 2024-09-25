//
//  HomeViewControllerViewModel.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation
import Combine
import UIKit

class HomeViewControllerViewModel: NSObject, ObservableObject {
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var errorMessage: String?
    @Published private(set) var dataSource: [HomeBookInfo] = []
    
    private(set) var isLoading: Bool = false
    
    private(set) var titleTappedSubject = PassthroughSubject<String, Never>()
    private(set) var itemSelectedSubject = PassthroughSubject<String, Never>()
    
    private func search(text: String) async throws -> [BookItem] {
        do {
            // 네트워크 요청을 async 방식으로 처리
            let bookInfo = try await networkManager.searchBooks(query: text)
            return bookInfo.items ?? []
        } catch {
            throw error
        }
    }
    
    actor HomeBookInfoStore {
        private(set) var homeBookInfoArray: [HomeBookInfo] = []
        
        func append(_ info: HomeBookInfo) {
            homeBookInfoArray.append(info)
        }
        
        func getSorted() -> [HomeBookInfo] {
            return homeBookInfoArray.sorted { $0.index < $1.index }
        }
    }
    
    func requestInitBookInfo(searchTextArray: [String], subject: SubjectType) async {
        isLoading = true
        
        let homeBookInfoStore = HomeBookInfoStore()
        await withTaskGroup(of: HomeBookInfo?.self) { group in
            for (index, text) in searchTextArray.enumerated() {
                group.addTask {
                    do {
                        let results = try await self.search(text: text).compactMap { bookInfo -> BookItem? in
                            guard let isEbook = bookInfo.saleInfo?.isEbook else { return nil }
                            return (subject == .eBook && isEbook) || (subject == .audioBook && !isEbook) ? bookInfo : nil
                        }
                        
                        guard !results.isEmpty else { return nil }
                        return HomeBookInfo(index: index, categoryTitle: text, bookInfos: results)
                    } catch {
                        logger("Error occurred while searching for \(text): \(error)")
                        return nil
                    }
                }
            }
            
            for await homeBookInfo in group {
                if let homeBookInfo = homeBookInfo {
                    await homeBookInfoStore.append(homeBookInfo)
                }
            }
        }
        
        DispatchQueue.main.async {
            Task {
                let sortedArray = await homeBookInfoStore.getSorted()
                self.dataSource = sortedArray
                self.isLoading = false
            }
        }
    }
    
    func titleTapAction(homeBookInfo: HomeBookInfo) {
        titleTappedSubject.send(homeBookInfo.categoryTitle)
    }
    
    func itemSelectAction(bookItemViewModel: BookItemViewModel) {
        itemSelectedSubject.send(bookItemViewModel.bookItem.id)
    }
}

struct HomeBookInfo {
    let index: Int
    let categoryTitle: String
    let bookInfos: [BookItem]
}

final class BookItemViewModel: NSObject, ObservableObject {
    let title: String
    let author: String
    let rating: String
    let imageUrl: String?
    let bookItem: BookItem
    let ratingHidden: Bool
    
    @Published private(set) var bookImage: UIImage?
    @Published private(set) var bookImageSize: CGSize = .zero
    
    init(item: BookItem) {
        self.bookItem = item
        self.title = bookItem.volumeInfo.title
        self.author = bookItem.volumeInfo.displayAuthors
        self.rating = bookItem.volumeInfo.averageRating ?? 0 > 0 ? bookItem.volumeInfo.displayRatingString : bookItem.volumeInfo.publishedDate ?? ""
        self.ratingHidden = bookItem.volumeInfo.hiddenRating
        
        let thumbnailUrl = bookItem.volumeInfo.imageLinks?.getThumbnailUrl()
        self.imageUrl = thumbnailUrl
        
        super.init()
        
        DispatchQueue.main.async {
            self.loadImage(url: self.imageUrl)
        }
    }
    
    private func loadImage(url: String?) {
        guard let imageUrl = url, let url = URL(string: imageUrl) else {
            self.bookImage = UIImage(systemName: "photo")
            self.bookImageSize = .zero
            return
        }
        
        // 비동기적으로 이미지 다운로드
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.bookImage = downloadedImage  // 이미지 업데이트
                    self?.bookImageSize = downloadedImage.size  // 이미지 크기 설정
                }
            } else {
                DispatchQueue.main.async {
                    self?.bookImage = UIImage(systemName: "photo")
                    self?.bookImageSize = .zero  // 기본 이미지 크기
                }
            }
        }.resume()
    }
    
}

