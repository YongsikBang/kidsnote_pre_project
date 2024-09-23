//
//  ViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import UIKit

class ViewController: UIViewController {
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(of: .splashText)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupConfigure()
        setupConstraint()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.showSplashView()
        }
    }
    
    private func setupConfigure() {
        view.backgroundColor = .white
        view.addSubview(infoLabel)
        
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showSplashView() {
        let splashView = SplashViewController()
        splashView.modalTransitionStyle = .crossDissolve
        splashView.modalPresentationStyle = .fullScreen
        self.navigationController?.setViewControllers([splashView], animated: true)
    }
}
