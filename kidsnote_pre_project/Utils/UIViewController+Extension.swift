//
//  UIViewController+Extension.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/24/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: .localized(of: .alertErrorTitle), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .localized(of: .alertOK), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openWebsite(with url: String) -> Bool {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        }
        return false
    }
}
