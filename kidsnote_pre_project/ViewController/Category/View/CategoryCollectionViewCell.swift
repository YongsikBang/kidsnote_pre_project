//
//  CategoryCollectionViewCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit
import Combine

class CategoryCollectionViewCell: UICollectionViewCell {
    private var cancellables = Set<AnyCancellable>()
    
    private let bookImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publishLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(publishLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),

            publishLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            publishLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            publishLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            publishLabel.heightAnchor.constraint(equalToConstant: 18),
            publishLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: CategoryCollectionViewModel, bookItem: BookItem) {
        contentView.backgroundColor = .clear
        titleLabel.text = bookItem.volumeInfo.title
        publishLabel.text = bookItem.volumeInfo.publisher
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        bookImageView.image = nil
        viewModel.$bookImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                bookImageView.image = image
            }
            .store(in: &cancellables)
    }
    
}
