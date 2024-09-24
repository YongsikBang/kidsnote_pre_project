//
//  BookDetailViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit
import Combine

class BookDetailViewController: UIViewController {
    private let bookID: String
    private let viewModel: BookDetailViewControllerViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var sharedContent: String = "책 정보를 불러오는 중입니다..."
    private var sharedImage: UIImage?
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .white
        return tableview
    }()
    
    init(bookId: String, viewModel: BookDetailViewControllerViewModel) {
        self.bookID = bookId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConfigure()
        setupConstraint()
        bindViewModel()
        
    }
    
    private func setupConfigure() {
        
        // 공유 버튼 추가
        let shareImage = UIImage(systemName: "square.and.arrow.up")
        let shareButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton

        view.addSubview(tableView)
        tableView.register(BookDetailTitleCell.self, forCellReuseIdentifier: BookDetailTitleCell.cellReuseIdentifier)
        tableView.register(BookDetailSampleAndWishCell.self, forCellReuseIdentifier: BookDetailSampleAndWishCell.cellReuseIdentifier)
        tableView.register(BookDetailBookInfoCell.self, forCellReuseIdentifier: BookDetailBookInfoCell.cellReuseIdentifier)
        tableView.register(BookDetailPublishDateCell.self, forCellReuseIdentifier: BookDetailPublishDateCell.cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        requestBookDetail()

        viewModel.$dataSource
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] bookDetail in
                guard let self else { return }
                if let sharedText = viewModel.sharedText {
                    sharedContent = sharedText
                }
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
        
        viewModel.$bookImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                guard let self else { return }
                if let image = image {
                    self.sharedImage = image
                }
            })
            .store(in: &cancellables)
    }
    
    private func requestBookDetail() {
        viewModel.detail(bookID: bookID)
    }
    
    // 공유 버튼이 눌렸을 때
    @objc private func shareButtonTapped() {
        let itemsToShare: [Any] = [sharedContent, sharedImage as Any]
        
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func navigationToDescriptionView(bookTitle: String, description: String) {
        let bookDescriptionView = BookDetailDescriptionViewController(title: bookTitle, description: description)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(bookDescriptionView, animated: true)
    }
}

extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.dataSource[indexPath.row]
        
        switch item.cellType {
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookDetailTitleCell.cellReuseIdentifier, for: indexPath) as? BookDetailTitleCell,
                    let cellData = item.titleCellInfo
            else { return UITableViewCell() }

            let title = cellData.title
            let autors = cellData.autors
            let pages = cellData.pages
            
            cell.configure(viewModel: viewModel, title: title, author: autors, page: pages)
            
            return cell
            
        case .sampleAndWish:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookDetailSampleAndWishCell.cellReuseIdentifier, for: indexPath) as? BookDetailSampleAndWishCell,
                  let cellData = item.sampleAndWishCellInfo
            else { return UITableViewCell() }
            
            cell.onBuyButtonTapped = {
                if !self.openWebsite(with: cellData.buyLink) {
                    self.showErrorAlert(message: .localized(of: .errorMessageNotBuy))
                }
            }
            
            cell.onWebLinkButtonTapped = {
                if !self.openWebsite(with: cellData.previewLink) {
                    self.showErrorAlert(message: .localized(of: .errorMessageNotPreView))
                }
            }
            return cell
            
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookDetailBookInfoCell.cellReuseIdentifier, for: indexPath) as? BookDetailBookInfoCell,
                  let cellData = item.infoCellData
            else { return UITableViewCell() }
            
            cell.configure(description: cellData.description)
            
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = .lightGray
            cell.selectedBackgroundView = selectedBackgroundView
            return cell
            
        case .publishDate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookDetailPublishDateCell.cellReuseIdentifier, for: indexPath) as? BookDetailPublishDateCell,
                  let cellData = item.publishCellData
            else { return UITableViewCell() }
            
            cell.configure(text: cellData.displayText)
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let item = viewModel.dataSource[indexPath.row]
        
        if item.cellType == .info {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.contentView.backgroundColor = .lightGray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let item = viewModel.dataSource[indexPath.row]
        
        if item.cellType == .info {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let item = viewModel.dataSource[indexPath.row]
        return item.cellType == .info
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.dataSource[indexPath.row]
        if item.cellType == .info {
            //설명 상세보기로 이동
            guard let cellData = item.infoCellData else { return}
            navigationToDescriptionView(bookTitle: cellData.bookTitle, description: cellData.description)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
