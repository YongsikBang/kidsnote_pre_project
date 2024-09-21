//
//  LocalizedString.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation

public struct LocalizedString {
    public struct StringInfo {
        private let key: StaticString
        private let defaultValue: String.LocalizationValue
        private let locale: Locale
        private let comment: StaticString?


        /// localized String을 만들기 위한 정보
        ///
        /// - Parameters:
        ///   - key: String 판별을 위한 id
        ///   - defaultValue: 기본으로 사용할 문구
        ///   - locale: locale
        ///   - comment: 주석(개발시 참고할 사항)
        public init(key: StaticString, defaultValue: String.LocalizationValue, locale: Locale = .current, comment: StaticString? = nil) {
            self.key = key
            self.defaultValue = defaultValue
            self.locale = locale
            self.comment = comment
        }

        fileprivate var localized: String {
            String(
                localized: key,
                defaultValue: defaultValue,
                locale: locale,
                comment: comment
            )
        }
    }
    
    public static func makeInfo(_ key: StaticString,_ defaultValue: String.LocalizationValue,_ comment: StaticString) -> LocalizedString {
        return LocalizedString(info: .init(key: key, defaultValue: defaultValue, comment: comment))
    }

    private let info: StringInfo
    public init(info: StringInfo) {
        self.info = info
    }

    var localized: String {
        info.localized
    }
}
