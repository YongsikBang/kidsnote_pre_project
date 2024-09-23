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
        
        tableView.register(BookDetailTitleCell.self, forCellReuseIdentifier: BookDetailTitleCell.cellReuseIdentifier)
        tableView.register(BookDetailSampleAndWishCell.self, forCellReuseIdentifier: BookDetailSampleAndWishCell.cellReuseIdentifier)
        tableView.register(BookDetailBookInfoCell.self, forCellReuseIdentifier: BookDetailBookInfoCell.cellReuseIdentifier)
        tableView.register(BookDetailRatingAndReviewCell.self, forCellReuseIdentifier: BookDetailRatingAndReviewCell.cellReuseIdentifier)
        tableView.register(BookDetailPublishDateCell.self, forCellReuseIdentifier: BookDetailPublishDateCell.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
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
                self.sharedContent = ""
            })
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                guard let self else { return }
                logger("message : \(message)")
            })
            .store(in: &cancellables)
    }
    
    private func requestBookDetail() {
        viewModel.detail(bookID: bookID)
    }
    
    // 공유 버튼이 눌렸을 때
    @objc private func shareButtonTapped() {
        let itemsToShare = [sharedContent]
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
