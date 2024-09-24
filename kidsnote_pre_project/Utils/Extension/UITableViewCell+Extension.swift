//
//  UITableViewCell+Extension.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/22/24.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var cellReuseIdentifier: String {
        return String(describing: Self.self)
    }
}
