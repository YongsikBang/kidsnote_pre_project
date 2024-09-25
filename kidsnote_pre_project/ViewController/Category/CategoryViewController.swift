//
//  CategoryViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit
import Combine

class CategoryViewController: UIViewController {
    
    private let categoryTitle: String
    private let viewModel: CategoryViewControllerViewModel
    private let subjectType: SubjectType
    
    private var cancellables = Set<AnyCancellable>()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(categoryTitle: String, viewModel: CategoryViewControllerViewModel, subject: SubjectType) {
        self.categoryTitle = categoryTitle
        self.viewModel = viewModel
        self.subjectType = subject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfigure()
        setupConstraint()
        bindViewModel()
    }
    
    private func setupConfigure() {
        self.view.backgroundColor = .white
        self.navigationItem.title = categoryTitle
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.requestCategoryBookList(text: categoryTitle, subject: subjectType)
        
        viewModel.$dataSource
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                collectionView.reloadData()
            })
            .store(in: &cancellables)
        
        viewModel.itemSelectSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] bookID in
                guard let self else { return }
                navigateToDetailView(bookID: bookID)
            })
            .store(in: &cancellables)
    }
    
    private func navigateToDetailView(bookID: String) {
        let bookDetailViewModel = BookDetailViewControllerViewModel(bookID: bookID)
        let bookDetailView = BookDetailViewController(bookId: bookID, viewModel: bookDetailViewModel)
        let backButton = UIBarButtonItem(title: categoryTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(bookDetailView, animated: true)
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        let bookItem = viewModel.dataSource[indexPath.row]
        let collectionViewModel = viewModel.collectionViewModelList[indexPath.row]
        cell.configure(with: collectionViewModel, bookItem: bookItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookItem = viewModel.dataSource[indexPath.row]
        viewModel.itemSelectAction(with: bookItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //화면 계산해서 동적으로 넓이 조정
        let padding: CGFloat = 20 * 2
        let interItemSpacing: CGFloat = 16
        let availableWidth = collectionView.frame.width - padding - interItemSpacing
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: 250)
    }
}
