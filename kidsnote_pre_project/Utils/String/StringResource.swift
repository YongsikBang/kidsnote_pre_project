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
    
    static let page = makeInfo("page", "페이지", "")
    static let bookInfo = makeInfo("bookInfo", "책 정보", "")
    static let publishDate = makeInfo("publishDate", "게시일", "")
    
    static let bookBuyDescription = makeInfo("bookBuyDescription", "Google Play 웹사이트에서 구매한 책을 이 앱에서 읽을 수 있습니다.", "")
    static let buyButtonText = makeInfo("buyButtonText", "구매하러 가기", "")
    static let webLinkButtonText = makeInfo("webLinkButtonText", "자세히 보러가기", "")
    
    static let errorMessageNotBuy = makeInfo("errorMessage_not_buy", "구매페이지가 제공되지 않습니다.", "구매 불가 오류 문구")
    static let errorMessageNotPreView = makeInfo("errorMessage_not_preview", "미리보기가 제공되지 않습니다.", "미리보기 오류 문구")
}
