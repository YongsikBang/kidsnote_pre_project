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
    
    func search(text: String) {
        networkManager.searchBooks(query: text)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { bookResponse in
                logger("bookResponse :\(bookResponse)", options: [.date,.codePosition])
                self.bookInfo = bookResponse.items ?? []
            })
            .store(in: &cancellables)
    }
    
    func detail(bookID: String) {
        networkManager.detailBookInfo(bookID: bookID)
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
}

