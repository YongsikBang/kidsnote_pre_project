//
//  UIImageView+Extension.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/22/24.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            logger("Invalid URL string: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                logger("Failed to download image: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                logger("Invalid response from server")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                logger("Failed to create image from data")
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()  // 작업 시작
    }
}
