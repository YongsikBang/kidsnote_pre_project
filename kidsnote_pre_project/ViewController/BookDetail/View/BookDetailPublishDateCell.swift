//
//  BookDetailPublishDateCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit

class BookDetailPublishDateCell: UITableViewCell {
    
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
        label.text = .localized(of: .publishDate)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publishedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
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
        bgView.addSubview(publishedLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            publishedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            publishedLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            publishedLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            publishedLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor)
        ])
    }
    
    func configure(text: String) {
        publishedLabel.text = text
    }

}
