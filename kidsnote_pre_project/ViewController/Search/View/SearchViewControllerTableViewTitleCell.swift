//
//  SearchViewControllerTableViewTitleCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/25/24.
//

import UIKit

class SearchViewControllerTableViewTitleCell: UITableViewCell {
    
    private var viewModel: SearchViewControllerViewModel?
    
    var buttonTappedAction: ((UIButton) -> Void)?
    
    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ebookButton: UIButton = {
        let button = UIButton()
        button.setTitle(.localized(of: .ebookButtonText), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.systemBlue, for: .selected)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let audioBookButton: UIButton = {
        let button = UIButton()
        button.setTitle(.localized(of: .audioBookButtonText), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.systemBlue, for: .selected)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = .localized(of: .searchInfoText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var topButtons = [UIButton]()
    
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
        contentView.addSubview(topStackView)
        
        topStackView.addArrangedSubview(ebookButton)
        topStackView.addArrangedSubview(audioBookButton)
        
        contentView.addSubview(lineView)
        contentView.addSubview(infoLabel)
        
        topButtons.append(ebookButton)
        topButtons.append(audioBookButton)
        
        ebookButton.addTarget(self, action: #selector(topButtonTapped(_:)), for: .touchUpInside)
        audioBookButton.addTarget(self, action: #selector(topButtonTapped(_:)), for: .touchUpInside)
        ebookButton.isSelected = true
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topStackView.heightAnchor.constraint(equalToConstant: 44),
            
            lineView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            infoLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(subject: SubjectType) {
        ebookButton.isSelected = subject == .eBook
        audioBookButton.isSelected = subject == .audioBook
    }
    
    @objc private func topButtonTapped(_ sender: UIButton) {
        
        buttonTappedAction?(sender)
    }
    
}
