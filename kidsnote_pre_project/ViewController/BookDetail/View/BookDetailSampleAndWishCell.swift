//
//  BookDetailSampleAndWishCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit

class BookDetailSampleAndWishCell: UITableViewCell {
    
    private enum ButtonStyleType {
        case buy
        case webLink
    }
    
    var onBuyButtonTapped: (() -> Void)?
    var onWebLinkButtonTapped: (() -> Void)?
    
    private let topLineView = createLineView()
    private let bottomLineView = createLineView()
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buyButton: UIButton = createButton(ofType: .buy, title: .localized(of: .buyButtonText))
    private let webLinkButton: UIButton = createButton(ofType: .webLink, title: .localized(of: .webLinkButtonText))
        
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.text = .localized(of: .bookBuyDescription)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraint()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func createButton(ofType type: ButtonStyleType, title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .buy:
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 1
        case .webLink:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
        }
        
        return button
    }
    
    private static func createLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupViews() {
        contentView.addSubview(topLineView)
        contentView.addSubview(bgView)
        contentView.addSubview(bottomLineView)
        
        bgView.addSubview(buyButton)
        bgView.addSubview(webLinkButton)
        bgView.addSubview(infoView)
        
        infoView.addSubview(infoImageView)
        infoView.addSubview(infoLabel)
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 1),
            topLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            bgView.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 20),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            buyButton.topAnchor.constraint(equalTo: bgView.topAnchor),
            buyButton.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 150),
            buyButton.heightAnchor.constraint(equalToConstant: 44),
            
            webLinkButton.topAnchor.constraint(equalTo: buyButton.topAnchor),
            webLinkButton.leadingAnchor.constraint(equalTo: buyButton.trailingAnchor, constant: 8),
            webLinkButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            webLinkButton.heightAnchor.constraint(equalTo: buyButton.heightAnchor),
            
            infoView.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 16),
            infoView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            
            infoImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            infoImageView.widthAnchor.constraint(equalToConstant: 20),
            infoImageView.heightAnchor.constraint(equalToConstant: 20),
            infoImageView.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            
            bottomLineView.topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 20),
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupAction() {
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        webLinkButton.addTarget(self, action: #selector(webLinkButtonTapped), for: .touchUpInside)
    }
    
    // 버튼 클릭 시 ViewModel로 이벤트 전달
    @objc private func buyButtonTapped() {
        onBuyButtonTapped?()
    }
    
    @objc private func webLinkButtonTapped() {
        onWebLinkButtonTapped?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
