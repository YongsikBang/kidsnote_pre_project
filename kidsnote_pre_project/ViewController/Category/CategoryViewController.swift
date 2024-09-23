//
//  CategoryViewController.swift
//  kidsnote_pre_project
//
//  Created by 방용식 on 9/23/24.
//

import UIKit

class CategoryViewController: UIViewController {

    private let categoryTitle: String
    private let viewModel: CategoryViewControllerViewModel
    
    init(categoryTitle: String, viewModel: CategoryViewControllerViewModel) {
        self.categoryTitle = categoryTitle
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger("viewDidLoad",options:[.codePosition])
        logger("categoryTitle : \(categoryTitle)",options:[.codePosition])
        logger("viewmodel : \(viewModel)",options:[.codePosition])
        // Do any additional setup after loading the view.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
