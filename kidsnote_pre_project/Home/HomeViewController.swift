//
//  HomeViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
   private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "HomeView"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
