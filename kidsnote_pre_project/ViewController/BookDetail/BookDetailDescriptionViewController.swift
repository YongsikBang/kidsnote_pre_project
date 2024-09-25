//
//  BookDetailDescriptionViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/24/24.
//

import UIKit

class BookDetailDescriptionViewController: UIViewController {

    private let bookTitle: String
    private let descript: String
    
    private let textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(title: String, description: String) {
        self.bookTitle = title
        self.descript = description
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraint()
        
        configure()
    }
    
    private func setupView() {
        self.navigationItem.title = bookTitle
        
        view.addSubview(textView)
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configure() {
        textView.setHTMLFromString(htmlText: descript)
    }
}

