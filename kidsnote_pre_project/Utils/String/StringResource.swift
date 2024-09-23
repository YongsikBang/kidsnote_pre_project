//
//  GlobalString.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation

extension LocalizedString {
    static let splashText = makeInfo("splash_label_text", "KidsNote Pre Project", "스플래쉬 화면 문구")
    static let searchBarPlaceHolder = makeInfo("searchBar_placeholder", "Play 북에서 검색", "서치바 플레이스홀더 문구")
    
    static let ebookButtonText = makeInfo("button_ebook", "eBook", "eBook 버튼 타이틀")
    static let audioBookButtonText = makeInfo("button_audiobook", "오디오북", "audiobook 버튼 타이틀")
    
    static let alertErrorTitle = makeInfo("alert_error_title", "Error", "오류 알럿 타이틀")
    static let alertOK = makeInfo("alert_ok", "OK", "알럿 OK 버튼 타이틀")
    
    static let navigationBackButtonText = makeInfo("navigation_back", "뒤로", "네비게이션 뒤로")
}
