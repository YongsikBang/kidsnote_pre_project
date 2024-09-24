//
//  BookDetailTitleCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit
import Combine

class BookDetailTitleCell: UITableViewCell {
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
        label.numberOfLines = 0
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
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        setupViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(bgView)
        
        bgView.addSubview(bookImageView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(authorLabel)
        bgView.addSubview(pageLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            // bgView 제약 조건
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // bookImageView 제약 조건
            bookImageView.topAnchor.constraint(equalTo: bgView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: 100),
            bookImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // titleLabel 제약 조건
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            // authorLabel 제약 조건
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            // pageLabel 제약 조건
            pageLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            pageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pageLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            // bgView의 bottomAnchor가 bookImageView의 bottomAnchor보다 0 이상으로 설정되도록
            bgView.bottomAnchor.constraint(greaterThanOrEqualTo: bookImageView.bottomAnchor),
                    
            // bgView의 bottomAnchor가 pageLabel의 bottomAnchor보다 0 이상으로 설정되도록
            bgView.bottomAnchor.constraint(greaterThanOrEqualTo: pageLabel.bottomAnchor),
        ])
    }
    
    func configure(viewModel: BookDetailViewControllerViewModel, title: String, author: String, page: String) {
        titleLabel.text = title
        authorLabel.text = author
        pageLabel.text = page
        
        viewModel.$bookImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                guard let self else { return }
                bookImageView.image = image
            })
            .store(in: &cancellables)
    }
    
}
