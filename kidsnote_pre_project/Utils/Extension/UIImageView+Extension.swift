//
//  UIImageView+Extension.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/22/24.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView {
    
    // 이미지 로드 메서드 (캐싱, 기본 이미지, 재시도, 로딩 상태 처리 포함)
    func loadImage(from urlString: String, retryCount: Int = 3,  completion: @escaping (CGSize?) -> Void) {
        // 1. URL 유효성 검사
        guard let url = URL(string: urlString) else {
            logger("Invalid URL string: \(urlString)")
            setPlaceholderImage()
            completion(nil)
            return
        }
        
        // 2. 캐시에 저장된 이미지가 있는지 확인
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            self.image = cachedImage
            completion(nil)
            return
        }
        
        // 3. 로딩 중을 나타내는 인디케이터 표시
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        activityIndicator.startAnimating()

        // 4. URLSession을 통한 비동기 이미지 로드
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // 5. 로딩 인디케이터 제거
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
            }
            
            // 6. 에러 처리 및 재시도 로직
            if let error = error {
                logger("Failed to download image: \(error)")
                if retryCount > 0 {
                    logger("Retrying... \(retryCount) attempts left")
                    self?.loadImage(from: urlString, retryCount: retryCount - 1, completion: completion)  // 재시도
                } else {
                    self?.setPlaceholderImage()
                    completion(nil)
                }
                return
            }
            
            // 7. HTTP 응답 상태 코드 검사
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                logger("Invalid response from server")
                DispatchQueue.main.async {
                    self?.setPlaceholderImage()
                }
                completion(nil)
                return
            }
            
            // 8. 데이터 유효성 검사 및 이미지 생성
            guard let data = data, let image = UIImage(data: data) else {
                logger("Failed to create image from data")
                DispatchQueue.main.async {
                    self?.setPlaceholderImage()
                }
                completion(nil)
                return
            }
            
            // 9. 이미지 캐싱
            ImageCache.shared.setObject(image, forKey: urlString as NSString)
            
            // 10. UI 업데이트
            DispatchQueue.main.async {
                self?.image = image
                let imageSize = image.size
                completion(imageSize)
            }
        }.resume()  // 네트워크 작업 시작
    }
    
    // 기본 이미지를 설정하는 메서드
    private func setPlaceholderImage() {
        DispatchQueue.main.async {
            self.image = UIImage(systemName: "photo")  // 기본 이미지
        }
    }
}
