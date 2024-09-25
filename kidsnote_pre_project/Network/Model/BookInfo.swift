//
//  BookInfo.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation

struct BookInfo: Codable {
    let kind: String
    let totalItems: Int
    let items:[BookItem]?
}

struct BookItem: Codable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo?
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let averageRating: Double?
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let imageLinks: ImageLinks?
    
    var displayAuthors: String {
        return authors?.joined(separator: ", ") ?? (publisher ?? "Unknown Author")
    }
    
    var displayRatingString: String {
        return "\(averageRating ?? 0)"
    }
    
    var hiddenRating: Bool {
        return averageRating ?? 0 > 0 ? false : true
    }
}

struct SaleInfo: Codable {
    let country, saleability: String?
    let isEbook: Bool
}

struct IndustryIdentifier: Codable {
    let type, identifier: String?
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
    
    func getThumbnailUrl() -> String? {
        return self.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
    }
    
}

