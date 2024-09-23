//
//  CategoryViewControllerViewModel.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit

class CategoryViewControllerViewModel: NSObject {
    var searchText: String?
    
    init(searchText: String? = nil) {
        self.searchText = searchText
    }
}
