//
//  NetworkManager.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation
import Combine

class NetworkManager {
    private let apiKey: String = "AIzaSyAKd6UY-a3q9xUWAT57DN8uHA6T7KkoxZ8"
    
    func searchBooks(query: String) -> AnyPublisher<BookInfo, Error> {
            let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(query)&key=\(apiKey)"
            logger("urlString : \(urlString)")
            guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }

            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: BookInfo.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
    
    func detailBookInfo(bookID: String) -> AnyPublisher<BookDetailInfo, Error> {
        let urlString = "https://www.googleapis.com/books/v1/volumes/\(bookID)"
        logger("urlString : \(urlString)")
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: BookDetailInfo.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
