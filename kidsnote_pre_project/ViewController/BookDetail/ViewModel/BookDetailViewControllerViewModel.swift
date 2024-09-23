//
//  BookDetailViewControllerViewModel.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit
import Combine

class BookDetailViewControllerViewModel: NSObject, ObservableObject {
    let bookID: String
    
    private let networkManager = NetworkManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var errorMessage: String?
    @Published private(set) var dataSource: [BookDetailData] = []
    
    init(bookID: String) {
        self.bookID = bookID
    }
    
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
    
}

struct BookDetailData {
    
}
