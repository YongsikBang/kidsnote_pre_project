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
    
    @Published private(set) var bookImage: UIImage?
    
    private(set) var sharedText: String?
    
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
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                makeSharedData(response)
                processBookDetail(response)
            })
            .store(in: &cancellables)
    }
    
    private func makeSharedData(_ response: BookDetailInfo) {
        sharedText = response.volumeInfo.title
    }
    
    private func processBookDetail(_ response: BookDetailInfo) {
        loadImage(url: response.volumeInfo.imageLinks?.getThumbnailUrl())
        
        var newDataSource: [BookDetailData] = []
        
        if let titleData = createTitleCellData(response) {
            newDataSource.append(titleData)
        }
        if let sampleAndWishData = createSampleAndWishCellData(response) {
            newDataSource.append(sampleAndWishData)
        }
        if let infoData = createInfoCellData(response) {
            newDataSource.append(infoData)
        }
        if let publishDateData = createPublishDateCellData(response) {
            newDataSource.append(publishDateData)
        }
        
        self.dataSource = newDataSource
        
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
    
    private func createTitleCellData(_ response: BookDetailInfo) -> BookDetailData? {
        let title = response.volumeInfo.title
        let authors = response.volumeInfo.displayAuthors
        let pages = "\(response.volumeInfo.pageCount ?? 0)" + .localized(of: .page)
        let isEbook = response.saleInfo?.isEbook ?? false
        let cellInfo = BookDetailTitleCellData(title: title, autors: authors, pages: pages, isEbook: isEbook)
        return BookDetailData(cellType: .title, titleCellInfo: cellInfo)
    }
    
    private func createSampleAndWishCellData(_ response: BookDetailInfo) -> BookDetailData? {
        guard let previewLink = response.volumeInfo.previewLink,
              let buyLink = response.saleInfo?.buyLink ?? response.volumeInfo.infoLink
        else { return nil }
        
        let cellInfo = BookDetailSampleAndWishCellData(previewLink: previewLink, buyLink: buyLink)
        return BookDetailData(cellType: .sampleAndWish, sampleAndWishCellInfo: cellInfo)
    }
        
    private func createInfoCellData(_ response: BookDetailInfo) -> BookDetailData? {
        guard let description = response.volumeInfo.description else { return nil }
        
        let cellInfo = BookDetailInfoCellData(cellTitle: .localized(of: .bookInfo), bookTitle: response.volumeInfo.title, description: description)
        return BookDetailData(cellType: .info, infoCellData: cellInfo)
    }
    
    private func createPublishDateCellData(_ response: BookDetailInfo) -> BookDetailData? {
        guard let publisher = response.volumeInfo.publisher,
                let publishedDate = response.volumeInfo.publishedDate
        else { return nil }
        
        let cellInfo = BookDetailPublishCellData(cellTitle: .localized(of: .publishDate), publisher: publisher, publishedDate: publishedDate)
        return BookDetailData(cellType: .publishDate, publishCellData: cellInfo)
    }
}

enum BookDetailCellType {
    case title
    case sampleAndWish
    case info
    case publishDate
}

struct BookDetailData {
    let cellType: BookDetailCellType
    let titleCellInfo: BookDetailTitleCellData?
    let sampleAndWishCellInfo: BookDetailSampleAndWishCellData?
    let infoCellData: BookDetailInfoCellData?
    let publishCellData: BookDetailPublishCellData?
    
    init(cellType: BookDetailCellType,
         titleCellInfo: BookDetailTitleCellData? = nil,
         sampleAndWishCellInfo: BookDetailSampleAndWishCellData? = nil,
         infoCellData: BookDetailInfoCellData? = nil,
         publishCellData: BookDetailPublishCellData? = nil) {
        self.cellType = cellType
        self.titleCellInfo = titleCellInfo
        self.sampleAndWishCellInfo = sampleAndWishCellInfo
        self.infoCellData = infoCellData
        self.publishCellData = publishCellData
    }
}

struct BookDetailTitleCellData {
    let title: String
    let autors: String
    let pages: String
    let isEbook: Bool
    
    var displayPages: String {
        var text =  isEbook ? String.localized(of: .subjectTypeEbook)  : String.localized(of: .subjectTypeAudioBook)
        return text + " · " + pages
    }
}

struct BookDetailSampleAndWishCellData {
    let previewLink: String
    let buyLink: String
}

struct BookDetailInfoCellData {
    let cellTitle: String
    let bookTitle: String
    let description: String
}

struct BookDetailPublishCellData {
    let cellTitle: String
    let publisher: String
    let publishedDate: String
    
    //게시일 문구 만들기
    var displayText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: publishedDate) {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let formattedDate = dateFormatter.string(from: date)
            
            return "\(formattedDate) · \(publisher)"
        } else {
            return publishedDate
        }
    }
    
}
