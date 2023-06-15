//
//  LaunchScreenViewController.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import Lottie
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class LaunchScreenViewController: LifePoopViewController, ViewType {
    
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "onboarding")
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.2
        return animationView
    }()
    
    public var viewModel: LaunchScreenViewModel?
    
    private let disposeBag = DisposeBag()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.play { [weak self] _ in
            self?.viewModel?.input.didFinishAnimating.accept(())
        }
    }

    public func bindInput(to viewModel: LaunchScreenViewModel) {
        let input = viewModel.input
        
        rx.viewWillAppear
            .bind(to: input.viewWillAppear)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: LaunchScreenViewModel) { }
    
    public override func layoutUI() {
        super.layoutUI()
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(250)
        }
    }
}
