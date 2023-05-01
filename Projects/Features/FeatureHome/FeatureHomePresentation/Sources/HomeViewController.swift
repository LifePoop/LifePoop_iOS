//
//  HomeViewController.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class HomeViewController: UIViewController, ViewType {
    
    public var viewModel: HomeViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    public func bindInput(to viewModel: HomeViewModel) {
        let input = viewModel.input
        
    }
    
    public func bindOutput(from viewModel: HomeViewModel) {
        let output = viewModel.output
        
    }
}

// MARK: - UI Configuration

private extension HomeViewController {
    func configureUI() {
        view.backgroundColor = .blue
        navigationItem.title = "Home"
    }
}

// MARK: - UI Layout

private extension HomeViewController {
    func layoutUI() {
        
    }
}
