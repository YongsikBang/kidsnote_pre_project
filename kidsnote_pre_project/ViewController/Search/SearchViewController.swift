//
//  SearchViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/24/24.
//

import UIKit

class SearchViewController: UIViewController {

    private let searchBar = UISearchBar()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue
        
        return button
    }()
    
    private let textView: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.placeholder = "Play 북에서 검색"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        logger("viewdidload", options: [.codePosition])
        // Do any additional setup after loading the view.
        
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(textView)
        topView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.topAnchor.constraint(equalTo: topView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: topView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor),
            textView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            lineView.topAnchor.constraint(equalTo: textView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)  // 액션 설정
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func backButtonTapped() {
            dismiss(animated: true, completion: nil)
        }

}
