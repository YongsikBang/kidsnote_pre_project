//
//  BookDetailInfo.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation

struct BookDetailInfo: Codable {
    let kind, id, etag: String
    let selfLink: String
    let volumeInfo: DetailVolumeInfo
    let saleInfo: DetailSaleInfo?
}

struct DetailVolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher, publishedDate, description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let pageCount: Int?
    let printType, mainCategory: String?
    let categories: [String]?
    let averageRating: Double?
    let ratingsCount: Int?
    let contentVersion: String?
    let imageLinks: DetailImageLinks?
    let language: String?
    let infoLink: String?
    let previewLink: String?
    let canonicalVolumeLink: String?
    
    var displayAuthors: String {
        return authors?.joined(separator: ", ") ?? (publisher ?? "Unknown Author")
    }
}

struct DetailImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
    let small, mediumlarge, extraLarge: String?
    
    func getThumbnailUrl() -> String? {
        return self.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
    }
}

struct DetailSaleInfo: Codable {
    let country, saleability: String?
    let isEbook: Bool?
    let listPrice, retailPrice: Price?
    let buyLink: String?
}

struct Price: Codable {
    let amount: Double?
    let currencyCode: String?
}


