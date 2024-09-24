//
//  UICollectionViewCell+Extension.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/22/24.
//

import Foundation
import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
