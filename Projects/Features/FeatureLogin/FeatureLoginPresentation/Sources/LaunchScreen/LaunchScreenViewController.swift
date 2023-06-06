//
//  LaunchScreenViewController.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class LaunchScreenViewController: UIViewController, ViewType {
    
    
    private let mainLogoImageView = UIImageView(image: ImageAsset.logoLarge.image)
    
    private let mainCharacterImageView = UIImageView(image: ImageAsset.characterLarge.image)

    public var viewModel: LaunchScreenViewModel?
    
    private let disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }

    public func bindInput(to viewModel: LaunchScreenViewModel) {
        let input = viewModel.input
        
        rx.viewWillAppear
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: input.viewWillAppear)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: LaunchScreenViewModel) { }
}

// MARK: - UI Configuration

private extension LaunchScreenViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension LaunchScreenViewController {
    func layoutUI() {
        let frameHeight = view.frame.height

        view.addSubview(mainLogoImageView)
        view.addSubview(mainCharacterImageView)
        
        mainLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(frameHeight*0.22)
        }
        
        mainCharacterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(frameHeight*0.38)
        }
    }
}
