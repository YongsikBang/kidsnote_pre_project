//
//  HomeBookCollectionViewCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/22/24.
//

import UIKit
import Combine
class HomeBookCollectionViewCell: UICollectionViewCell {
    private var cancellables = Set<AnyCancellable>()
    
    let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 별표 이미지 뷰
    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")  // SF Symbol 사용 (별 모양)
        imageView.tintColor = .systemGray  // 별 색상
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        contentView.addSubview(authorLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(starImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // bookImageView constraints
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // titleLabel constraints
            titleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 12),
            
            // authorLabel constraints
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 12),
            
            // ratingLabel constraints
            ratingLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: 12),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // starImageView constraints (별표는 ratingLabel 옆에 배치) - 현재는 rating이 없어서 사용안함
            starImageView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            starImageView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 4),
            starImageView.widthAnchor.constraint(equalToConstant: 12),
            starImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configure(with viewModel: BookItemViewModel) {
        contentView.backgroundColor = .clear
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        ratingLabel.text = viewModel.rating
        starImageView.isHidden = true
        
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
