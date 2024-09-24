//
//  UITextView+Extension.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/24/24.
//

import Foundation
import UIKit

extension UITextView {
    func setHTMLFromString(htmlText: String) {
        guard let data = htmlText.data(using: .utf8) else { return }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            self.attributedText = attributedString
        } catch {
            logger("HTML 파싱 오류: \(error)")
        }
    }
}
