//
//  CategoryViewControllerViewModel.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit
import Combine

class CategoryViewControllerViewModel: NSObject, ObservableObject {
    var searchText: String?
    
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var dataSource: [BookItem] = []
    
    var collectionViewModelList: [CategoryCollectionViewModel] = []
    
    private(set) var itemSelectSubject = PassthroughSubject<String, Never>()
    
    init(searchText: String? = nil) {
        self.searchText = searchText
    }
    
    private func search(text: String) async throws -> [BookItem] {
        do {
            let bookInfo = try await networkManager.searchBooks(query: text)
            return bookInfo.items ?? []
        } catch {
            throw error
        }
    }
    
    func requestCategoryBookList(text: String) {
        Task {
            let results = try await self.search(text: text)
            logger("result : \(results)",options: [.codePosition])
            self.dataSource = results
            
            collectionViewModelList = self.dataSource.map { CategoryCollectionViewModel(item: $0)}
        }
    }
    
    func itemSelectAction(with bookItem: BookItem) {
        itemSelectSubject.send(bookItem.id)
    }
}

class CategoryCollectionViewModel: NSObject, ObservableObject {
    let title: String
    let publisher: String
    let imageUrl: String?
    let bookItem: BookItem
    
    @Published private(set) var bookImage: UIImage?
    @Published private(set) var bookImageSize: CGSize = .zero
    
    init(item: BookItem) {
        self.bookItem = item
        self.title = bookItem.volumeInfo.title
        self.publisher = bookItem.volumeInfo.publisher ?? "Unknown Author"
        
        let thumbnailUrl = bookItem.volumeInfo.imageLinks?.getThumbnailUrl()
        self.imageUrl = thumbnailUrl
        
        super.init()
        
        DispatchQueue.main.async {
            self.loadImage()
        }
    }
    
    private func loadImage() {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.bookImage = UIImage(systemName: "photo")
            self.bookImageSize = .zero
            return
        }
        
        logger("imageUrl : \(imageUrl)")
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
