//
//  SearchViewControllerViewModel.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/25/24.
//

import UIKit
import Combine

class SearchViewControllerViewModel: NSObject, ObservableObject {
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var dataSource: [SearchCellData] = [] {
        didSet {
            if oldValue.isEmpty && dataSource.isEmpty {
                return
            }
        }
    }
    
    @Published private(set) var bookImage: UIImage?
    
    var isLoading: Bool = false
    
    private func search(text: String) async throws -> [BookItem] {
        do {
            // 네트워크 요청을 async 방식으로 처리
            let bookInfo = try await networkManager.searchBooks(query: text)
            return bookInfo.items ?? []
        } catch {
            throw error
        }
    }
    
    func requestSearch(text: String, subject: SubjectType) {
        isLoading = true
        Task {
            let result = try await search(text: text)
            createSearchCellData(result, subject: subject)
        }
    }
    
    private func createSearchCellData(_ result: [BookItem], subject: SubjectType) {
        let first = SearchCellData(cellType: .title, bookData: nil, subject: subject, cellViewModel: nil)
        
        let dummy: [SearchCellData] = [first] + result.compactMap { bookItem -> SearchCellData? in
            let isEbook = bookItem.saleInfo?.isEbook ?? false
            
            let shouldInclude: Bool = (subject == .eBook && isEbook) || (subject == .audioBook && !isEbook)
            
            if shouldInclude {
                let viewModel = SearchCellViewModel(bookImageUrl: bookItem.volumeInfo.imageLinks?.getThumbnailUrl())
                return SearchCellData(cellType: .data, bookData: bookItem, subject: subject, cellViewModel: viewModel)
            }
            return nil
        }
        
        DispatchQueue.main.async {
            self.dataSource = dummy
            self.isLoading = false
        }
    }
    
    func resetDataSource() {
        if !dataSource.isEmpty {
            dataSource.removeAll()
        }
    }
    
}

enum SubjectType: String {
    case eBook
    case audioBook
}

enum SearchCellType {
    case title
    case data
}

struct SearchCellData {
    let cellType: SearchCellType
    let bookData: BookItem?
    let subject: SubjectType
    let cellViewModel: SearchCellViewModel?
    
    var displaySubject: String {
        switch subject {
        case .eBook:
            return "eBook"
        case .audioBook:
            return "오디오북"
        }
    }
}

final class SearchCellViewModel: NSObject, ObservableObject {
    private let bookImageUrl: String?
    
    @Published private(set) var bookImage: UIImage?
    
    init(bookImageUrl: String?) {
        self.bookImageUrl = bookImageUrl
        
        super.init()
        
        DispatchQueue.main.async {
            self.loadImage(url: self.bookImageUrl)
        }
    }
    
    private func loadImage(url: String?) {
        guard let imageUrl = url, let url = URL(string: imageUrl) else {
            self.bookImage = UIImage(systemName: "photo")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            DispatchQueue.main.async {
                self?.bookImage = (data.flatMap { UIImage(data: $0) }) ?? UIImage(systemName: "photo")
            }
        }.resume()
    }
    
}
