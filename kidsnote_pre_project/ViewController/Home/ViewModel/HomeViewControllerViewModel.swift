//
//  HomeViewControllerViewModel.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation
import Combine
import UIKit

final class HomeViewControllerViewModel: NSObject {
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var dataSource: [HomeBookInfo] = []
    
    var isLoading: Bool = false
    
    var titleTappedSubject = PassthroughSubject<String, Never>()
    var itemSelectedSubject = PassthroughSubject<String, Never>()
    
    func detail(bookID: String) {
        networkManager.detailBookInfo(bookID: bookID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                logger("response : \(response)", options: [.date,.codePosition])
            })
            .store(in: &cancellables)
    }
    
    func search(text: String) async throws -> [BookItem] {
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

    func requestInitBookInfo(searchTextArray: [String]) async {
        isLoading = true  // 데이터 로드 시작 시 로딩 상태를 true로 설정
        
        let homeBookInfoStore = HomeBookInfoStore()
        await withTaskGroup(of: HomeBookInfo?.self) { group in
            for (index, text) in searchTextArray.enumerated() {
                group.addTask {
                    do {
                        let results = try await self.search(text: text)
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

class BookItemViewModel {
    let title: String
    let author: String
    let rating: String
    let imageUrl: String?
    let bookItem: BookItem
    
    @Published var bookImage: UIImage?
    @Published var bookImageSize: CGSize = .zero
    
    init(item: BookItem) {
        self.bookItem = item
        self.title = bookItem.volumeInfo.title
        self.author = bookItem.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author"
        self.rating = bookItem.volumeInfo.publishedDate ?? ""
        
        let thumbnailUrl = bookItem.volumeInfo.imageLinks?.thumbnail
        let secureImageUrl = thumbnailUrl?.replacingOccurrences(of: "http://", with: "https://")
        self.imageUrl = secureImageUrl
        
        loadImage()
    }
    
    private func loadImage() {
            guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
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

