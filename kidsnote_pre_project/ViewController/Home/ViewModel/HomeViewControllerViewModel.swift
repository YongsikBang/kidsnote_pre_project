//
//  HomeViewControllerViewModel.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation
import Combine

class HomeViewControllerViewModel {
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var bookInfo: [BookItem] = []
    @Published var errorMessage: String?
    @Published var dataSource: [HomeBookInfo] = []
    
//        func search(text: String) {
//            networkManager.searchBooks(query: text)
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        self.errorMessage = error.localizedDescription
//                    }
//                }, receiveValue: { bookResponse in
//                    logger("bookResponse :\(bookResponse)", options: [.date,.codePosition])
//                    self.bookInfo = bookResponse.items ?? []
//                })
//                .store(in: &cancellables)
//        }
    
    func detail(bookID: String) {
        networkManager.detailBookInfo(bookID: bookID)
            .subscribe(on: DispatchQueue.global())
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
        //다중호출 처리를 위해 사용
        //중복 호출 확인을 위해 isContinued로 체크
        try await withCheckedThrowingContinuation { continuation in

            var isContinued = false

            networkManager.searchBooks(query: text)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    if isContinued { return }

                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        isContinued = true
                    }
                }, receiveValue: { [weak self] bookInfo in
                    guard let self = self else { return }
                    if isContinued { return }
                    continuation.resume(returning: bookInfo.items ?? [])
                    isContinued = true
                })
                .store(in: &self.cancellables)
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
        resetDataSource()
        
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
                    await homeBookInfoStore.append(homeBookInfo)  // Actor를 통해 안전하게 배열 수정
                }
            }
        }

        DispatchQueue.main.async {
            Task {
                let sortedArray = await homeBookInfoStore.getSorted()
                self.dataSource = sortedArray
                logger("dataSource : \(self.dataSource)", options: [.date, .codePosition])
            }
        }
    }
    
    private func resetDataSource() {
        if dataSource.count > 0 {
            dataSource.removeAll()
            dataSource = []
        }
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
    
    init(bookItem: BookItem) {
        self.title = bookItem.volumeInfo.title
        self.author = bookItem.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author"
        self.rating = bookItem.volumeInfo.publishedDate ?? ""
        
        let thumbnailUrl = bookItem.volumeInfo.imageLinks?.thumbnail
        let secureImageUrl = thumbnailUrl?.replacingOccurrences(of: "http://", with: "https://")
        self.imageUrl = secureImageUrl
    }
}

