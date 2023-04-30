//
//  LoginViewController.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class LoginViewController: UIViewController, ViewType {
    
    private lazy var nextFlowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var fetchAccessTokenButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fetch AccessToken", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    public var viewModel: LoginViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    public func bindInput(to viewModel: LoginViewModel) {
        let input = viewModel.input
        
        nextFlowButton.rx.tap
            .bind(to: input.nextButtonDidTap)
            .disposed(by: disposeBag)
        
        fetchAccessTokenButton.rx.tap
            .bind(to: input.fetchAccessTokenButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: LoginViewModel) {
        
    }
}

// MARK: - UI Configuration

private extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .systemGray4
        navigationItem.title = "Login"
    }
}

// MARK: - UI Layout

private extension LoginViewController {
    func layoutUI() {
        view.addSubview(nextFlowButton)
        view.addSubview(fetchAccessTokenButton)
        
        nextFlowButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        fetchAccessTokenButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
        }
    }
}
