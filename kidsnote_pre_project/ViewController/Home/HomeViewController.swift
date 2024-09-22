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
    
    private let searchBar = UISearchBar()
    
    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ebookButton: UIButton = {
        let button = UIButton()
        button.setTitle(.localized(of: .ebookButtonText), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.systemBlue, for: .selected)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let audioBookButton: UIButton = {
        let button = UIButton()
        button.setTitle(.localized(of: .audioBookButtonText), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.systemBlue, for: .selected)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var topButtons = [UIButton]()
    
    let ebookSearchArray = ["추천 ebook", "건강 정신 신체", "소설 문학", "번들 할인", "만화", "최다 판매 eBook"]
    let audioBookSearchArray = ["추천 audioBook", "건강 정신 신체", "소설 문학", "번들 할인", "만화", "최다 판매 audioBook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigure()
        setupConstraint()
        bindViewModel()
        requestEBookInfo()
    }
    
    private func setupConfigure() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        searchBar.placeholder = .localized(of: .searchBarPlaceHolder)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(ebookButton)
        topStackView.addArrangedSubview(audioBookButton)
        ebookButton.addTarget(self, action: #selector(topButtonTapped(_:)), for: .touchUpInside)
        audioBookButton.addTarget(self, action: #selector(topButtonTapped(_:)), for: .touchUpInside)
        
        topButtons.append(ebookButton)
        topButtons.append(audioBookButton)
        
        view.addSubview(lineView)
        
        view.addSubview(tableView)
        tableView.register(HomeTableViewItemCell.self, forCellReuseIdentifier: HomeTableViewItemCell.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            topStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topStackView.heightAnchor.constraint(equalToConstant: 44),
            
            lineView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func bindViewModel() {
        viewModel.$bookInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] model in
                guard let self else { return }
                logger("total book info :\(model.count)", options: [.date,.codePosition])
                tableView.reloadData()
            })
            .store(in: &cancellable)
        
        viewModel.$dataSource
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] model in
                guard let self else { return }
                tableView.reloadData()
            })
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                guard let self else { return }
                if let message = message {
                    showErrorAlert(message: message)
                }
            })
            .store(in: &cancellable)
    }
    
    private func requestEBookInfo() {
        Task {
            await viewModel.requestInitBookInfo(searchTextArray: ebookSearchArray)
        }
        ebookButton.isSelected = true
        
    }
    
    private func requestBookDetail() {
        let bookId = "RMDcnQEACAAJ"
        viewModel.detail(bookID: bookId)
    }
    
    @objc private func topButtonTapped(_ sender: UIButton) {
        topButtons.forEach { $0.isSelected = false}
        sender.isSelected = true
        
        let searchTextArray: [String]
        
        switch sender {
        case ebookButton:
            searchTextArray = ebookSearchArray
        case audioBookButton:
            searchTextArray = audioBookSearchArray
        default:
            searchTextArray = ebookSearchArray
        }
        
        Task {
            await viewModel.requestInitBookInfo(searchTextArray: searchTextArray)
        }
        
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: .localized(of: .alertErrorTitle), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .localized(of: .alertOK), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.resignFirstResponder()
//        viewModel.search(text: searchText)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookItem = viewModel.dataSource[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewItemCell.cellReuseIdentifier, for: indexPath) as? HomeTableViewItemCell else { return UITableViewCell() }
        cell.configure(with: bookItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
