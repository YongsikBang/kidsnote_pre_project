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
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        logger("[NETWORK] urlString : \(urlString)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ (data, response) in
                // 받은 데이터를 문자열로 변환하여 로깅
                if let jsonString = String(data: data, encoding: .utf8) {
                    logger("[NETWORK] Raw JSON response: \(jsonString)")
                }
                return data
            }
            .decode(type: BookInfo.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<BookInfo, Error> in
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        logger("[NETWORK] Data corrupted: \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        logger("[NETWORK] Key '\(key.stringValue)' not found: \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        logger("[NETWORK] Type mismatch for type '\(type)': \(context.debugDescription)")
                    case .valueNotFound(let value, let context):
                        logger("[NETWORK] Value '\(value)' not found: \(context.debugDescription)")
                    @unknown default:
                        logger("[NETWORK] Unknown decoding error: \(error)")
                    }
                } else {
                    logger("[NETWORK] General error: \(error.localizedDescription)")
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func detailBookInfo(bookID: String) -> AnyPublisher<BookDetailInfo, Error> {
        let urlString = "https://www.googleapis.com/books/v1/volumes/\(bookID)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        logger("[NETWORK] urlString : \(urlString)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ (data, response) in
                // 받은 데이터를 문자열로 변환하여 로깅
                if let jsonString = String(data: data, encoding: .utf8) {
                    logger("[NETWORK] Raw JSON response: \(jsonString)")
                }
                return data
            }
            .decode(type: BookDetailInfo.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<BookDetailInfo, Error> in
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        logger("[NETWORK] Data corrupted: \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        logger("[NETWORK] Key '\(key.stringValue)' not found: \(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        logger("[NETWORK] Type mismatch for type '\(type)': \(context.debugDescription)")
                    case .valueNotFound(let value, let context):
                        logger("[NETWORK] Value '\(value)' not found: \(context.debugDescription)")
                    @unknown default:
                        logger("[NETWORK] Unknown decoding error: \(error)")
                    }
                } else {
                    logger("[NETWORK] General error: \(error.localizedDescription)")
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
}
