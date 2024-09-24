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
    private var cancellables = Set<AnyCancellable>()
    
    private let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    let ebookSearchArray = ["추천 ebook", "건강/정신/신체", "소설/문학", "번들 할인", "만화", "최다 판매 eBook"]
    let audioBookSearchArray = ["추천 오디오북", "자서전/전기", "비즈니스/투자", "자기계발", "최다 판매 오디오북"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
        setupConstraint()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupConfigure() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        searchBar.placeholder = .localized(of: .searchBarPlaceHolder)
        searchBar.delegate = self
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
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
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
        requestEBookInfo()
        
        viewModel.$dataSource
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] model in
                guard let self else { return }
                tableView.reloadData()
            })
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                guard let self else { return }
                if let message = message {
                    showErrorAlert(message: message)
                }
            })
            .store(in: &cancellables)
        
        // titleTappedSubject 구독
        viewModel.titleTappedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categoryTitle in
                guard let self else { return }
                
                navigationToNext(type: .category, categoryTitle: categoryTitle)
            }
            .store(in: &cancellables)
        
        // itemSelectedSubject 구독
        viewModel.itemSelectedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookID in
                guard let self else { return }
                navigationToNext(type: .detail, bookID: bookID)
            }
            .store(in: &cancellables)
    }
    
    private func requestEBookInfo() {
        Task {
            await viewModel.requestInitBookInfo(searchTextArray: ebookSearchArray)
        }
        ebookButton.isSelected = true
        
    }
    
    @objc private func topButtonTapped(_ sender: UIButton) {
        // ViewModel에서 데이터 로드 중인 경우 버튼 동작을 막음
        if viewModel.isLoading {
            logger("Data is currently loading, please wait")
            return
        }
        
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
    
    private enum NextViewType {
        case category
        case detail
    }
    
    private func navigationToNext(type: NextViewType, categoryTitle: String? = nil, bookID: String? = nil) {
        let backButton = UIBarButtonItem(title: .localized(of: .navigationBackButtonText), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        switch type {
        case .category:
            guard let categoryTitle = categoryTitle else { return }
            let categoryViewModel = CategoryViewControllerViewModel(searchText: categoryTitle)
            let categoryView = CategoryViewController(categoryTitle: categoryTitle, viewModel: categoryViewModel)
            self.navigationController?.pushViewController(categoryView, animated: true)
        case .detail:
            guard let bookID = bookID else { return }
            let bookDetailViewmodel = BookDetailViewControllerViewModel(bookID: bookID)
            let bookDetailView = BookDetailViewController(bookId: bookID, viewModel: bookDetailViewmodel)
            self.navigationController?.pushViewController(bookDetailView, animated: true)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchViewController = SearchViewController()
        
        let navController = UINavigationController(rootViewController: searchViewController)
        
        navController.transitioningDelegate = self
        navController.modalPresentationStyle = .overFullScreen
        
        present(navController, animated: true, completion: {
            searchBar.resignFirstResponder()
        })
        
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SearchTransitionAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SearchTransitionAnimator(isPresenting: false)
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
        cell.titleTappedAction = { [weak self] homeBookInfo in
            guard let self else { return }
            if let homeBookInfo = homeBookInfo {
                viewModel.titleTapAction(homeBookInfo: homeBookInfo)
            }
        }
        cell.itemSelectedAction = { [weak self] bookInfo in
            guard let self else { return }
            viewModel.itemSelectAction(bookItemViewModel: bookInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

