//
//  SearchViewControllerTableViewDataCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/25/24.
//

import UIKit
import Combine

class SearchViewControllerTableViewDataCell: UITableViewCell {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 별표 이미지 뷰
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")  // SF Symbol 사용 (별 모양)
        imageView.tintColor = .systemGray  // 별 색상
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupViews() {
        contentView.addSubview(bgView)
        
        bgView.addSubview(bookImageView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(authorLabel)
        bgView.addSubview(subjectLabel)
        bgView.addSubview(ratingLabel)
        bgView.addSubview(starImageView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            bookImageView.topAnchor.constraint(equalTo: bgView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: 100),
            bookImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            subjectLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            subjectLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: subjectLabel.topAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: subjectLabel.trailingAnchor, constant: 4),
            
            starImageView.topAnchor.constraint(equalTo: ratingLabel.topAnchor),
            starImageView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 4),
            starImageView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 12),
            starImageView.heightAnchor.constraint(equalToConstant: 12),
            starImageView.trailingAnchor.constraint(lessThanOrEqualTo: bgView.trailingAnchor),
            
            bgView.bottomAnchor.constraint(greaterThanOrEqualTo: bookImageView.bottomAnchor),
            bgView.bottomAnchor.constraint(greaterThanOrEqualTo: subjectLabel.bottomAnchor)
        
        ])
    }
    
    func configure(viewModel: SearchCellViewModel, title: String, authors: String, subject: String?, rating: String?, ratingHidden: Bool) {
        titleLabel.text = title
        authorLabel.text = authors
        subjectLabel.text = subject
        ratingLabel.text = rating
        
        ratingLabel.isHidden = ratingHidden
        starImageView.isHidden = ratingHidden
        
        viewModel.$bookImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                guard let self else { return }
                bookImageView.image = image
            })
            .store(in: &cancellables)
    }
    

}
