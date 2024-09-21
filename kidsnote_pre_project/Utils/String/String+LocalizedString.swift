//
//  String+LocalizedString.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation

public extension String {
    
    static func localized(of localization: LocalizedString, arguments: CVarArg...) -> String {
        return if arguments.count > 0 {
            String.localizedStringWithFormat(localization.localized, arguments)
        }
        else {
            localization.localized
        }
    }
}
