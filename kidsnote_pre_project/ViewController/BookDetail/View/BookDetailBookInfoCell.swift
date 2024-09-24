//
//  BookDetailTableViewCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit

class BookDetailBookInfoCell: UITableViewCell {
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = .localized(of: .bookInfo)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(arrowImageView)
        bgView.addSubview(descriptionLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
        
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            
            arrowImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            arrowImageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 120),
            descriptionLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            
        ])
    }
    
    func configure(description: String) {
        descriptionLabel.setHTMLFromString(htmlText: description)
    }

}
