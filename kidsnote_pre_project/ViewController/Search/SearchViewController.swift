//
//  SearchViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/24/24.
//

import UIKit
import Combine
class SearchViewController: UIViewController {

    private let viewModel = SearchViewControllerViewModel()
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.placeholder = .localized(of: .searchTextfieldPlaceHolder)
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

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
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(textField)
        topView.addSubview(lineView)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)  // 액션 설정
        
        textField.delegate = self
        textField.becomeFirstResponder()
        
        view.addSubview(tableView)
        tableView.register(SearchViewControllerTableViewTitleCell.self, forCellReuseIdentifier: SearchViewControllerTableViewTitleCell.cellReuseIdentifier)
        tableView.register(SearchViewControllerTableViewDataCell.self, forCellReuseIdentifier: SearchViewControllerTableViewDataCell.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
    }
    
    private func setupConstraint() {
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
            
            textField.topAnchor.constraint(equalTo: topView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: backButton.trailingAnchor),
            textField.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            lineView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$dataSource
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] model in
                guard let self else { return }

                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            })
            .store(in: &cancellables)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func navigateToDetailView(bookID: String) {
        let bookDetailViewModel = BookDetailViewControllerViewModel(bookID: bookID)
        let bookDetailView = BookDetailViewController(bookId: bookID, viewModel: bookDetailViewModel)
        let backButton = UIBarButtonItem(title: .localized(of: .navigationBackButtonText), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(bookDetailView, animated: true)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() 

        //검색하기
        if let text = textField.text {
            viewModel.requestSearch(text: text, subject: .eBook)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if currentText?.isEmpty == true {
            
            DispatchQueue.main.async {
                self.viewModel.resetDataSource()
                self.tableView.isHidden = true
            }
            
        }
        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.dataSource[indexPath.row]
        switch item.cellType {
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewControllerTableViewTitleCell.cellReuseIdentifier, for: indexPath) as? SearchViewControllerTableViewTitleCell
            else { return UITableViewCell() }
            cell.configure(subject: item.subject)
            cell.buttonTappedAction = { [weak self] button in
                guard let self  else { return }
                let subjectType: SubjectType = button.tag == 0 ? .eBook : .audioBook
                let searchText = textField.text ?? ""
                viewModel.requestSearch(text: searchText, subject: subjectType)
            }
            return cell
        case .data:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewControllerTableViewDataCell.cellReuseIdentifier, for: indexPath) as? SearchViewControllerTableViewDataCell,
                  let bookData = item.bookData,
                  let viewModel = item.cellViewModel
            else { return UITableViewCell() }
            
            let title = bookData.volumeInfo.title
            let author = bookData.volumeInfo.displayAuthors
            let subject = item.displaySubject
            let rating = bookData.volumeInfo.displayRatingString
            let ratingHidden = bookData.volumeInfo.hiddenRating
            
            cell.configure(viewModel: viewModel, title: title, authors: author, subject: subject, rating: rating, ratingHidden: ratingHidden)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.dataSource[indexPath.row]
        guard let cellData = item.bookData else { return }
        
        if item.cellType == .data {
            navigateToDetailView(bookID: cellData.id)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
