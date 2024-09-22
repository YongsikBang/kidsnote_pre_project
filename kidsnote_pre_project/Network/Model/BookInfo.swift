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
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let imageLinks: ImageLinks?
}

struct IndustryIdentifier: Codable {
    let type, identifier: String?
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}

