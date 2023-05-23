//
//  LifePoopViewController.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

open class LifePoopViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    open func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationItem.backBarButtonItem = LifePoopBackBarButtonItem()
    }
    
    open func layoutUI() { }
}
