//
//  HomeViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation
import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewControllerViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "HomeView"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        bindViewModel()
        requestEBookInfo()
    }
    
    private func bindViewModel() {
        viewModel.$bookInfo
            .sink(receiveValue: { [weak self] model in
                guard let self else { return }
                logger("total book info :\(model.count)", options: [.date,.codePosition])
                for bookItem in model {
                    logger("book :\(bookItem)", options: [.date,.codePosition])
                    logger("book title :\(bookItem.volumeInfo.title)", options: [.date,.codePosition])
                    logger("book authors :\(bookItem.volumeInfo.authors)", options: [.date,.codePosition])
                    
                }
            })
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .sink(receiveValue: { [weak self] message in
                guard let self else { return }
                if let message = message {
                    logger("error Message : \(message)")
                }
            })
            .store(in: &cancellable)
    }
    
    private func requestEBookInfo() {
        let searchText = "subject:ebook"
        viewModel.search(text: searchText)
    }
    
    private func requestBookDetail() {
        let bookId = "RMDcnQEACAAJ"
        viewModel.detail(bookID: bookId)
    }
    
}
