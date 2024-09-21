//
//  SplashViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/21/24.
//

import UIKit

class SplashViewController: UIViewController {
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
        
        setupConfigure()
        setupConstraint()
        startSplashAnimation()
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
    
    private func startSplashAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animatedLabel()
        }
    }
    
    private func animatedLabel() {
        UIView.animate(withDuration: 1.0, animations: {
            self.infoLabel.alpha = 0.0
        }, completion: { _ in
            self.navigateToHome()
        })
    }
    
    private func navigateToHome() {
        let homeView = HomeViewController()
        homeView.modalTransitionStyle = .crossDissolve
        homeView.modalPresentationStyle = .fullScreen
        present(homeView, animated: true)
    }
}
