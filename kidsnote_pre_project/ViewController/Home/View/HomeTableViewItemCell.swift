//
//  HomeTableViewCell.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/22/24.
//

import UIKit

class HomeTableViewItemCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
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

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
        }()
    
    private var bookViewModels = [BookItemViewModel]()
    
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

        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(arrowImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleViewTapped))
        titleView.addGestureRecognizer(tapGesture)
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(HomeBookCollectionViewCell.self, forCellWithReuseIdentifier: HomeBookCollectionViewCell.reuseIdentifier) 
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20),
            arrowImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        logger("collectionview frame : \(collectionView.frame)")
    }
    
    func configure(with homeBookInfo: HomeBookInfo) {
        titleLabel.text = homeBookInfo.categoryTitle
        bookViewModels = homeBookInfo.bookInfos.map { BookItemViewModel(bookItem: $0)}
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.reloadData()
    }
    
    @objc private func titleViewTapped() {
        logger("titleViewTapped")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBookCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeBookCollectionViewCell else { return UICollectionViewCell() }
        let bookViewModel = bookViewModels[indexPath.row]
        cell.configure(with: bookViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let padding: CGFloat = 40  // 좌우 padding 합계 (양쪽이 20씩)
        let minimumLineSpacing: CGFloat = 16  // 셀 간 간격
        
        // 셀 2개의 총 너비 = collectionView 너비 - 좌우 패딩 - 셀 간 간격
        let cellWidth = (collectionViewWidth - padding - minimumLineSpacing) / 2
        let cellHeight: CGFloat = 200  // 원하는 셀 높이 설정
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
