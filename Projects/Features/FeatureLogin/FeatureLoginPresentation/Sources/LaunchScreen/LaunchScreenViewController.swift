//
//  LaunchScreenViewController.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import SnapKit

import DesignSystem
import Utils

public final class LaunchScreenViewController: UIViewController, ViewType {
    
    
    private let mainLogoImageView = UIImageView(image: ImageAsset.logoLarge.image)
    
    private let mainCharacterImageView = UIImageView(image: ImageAsset.characterLarge.image)

    public var viewModel: LaunchScreenViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
        
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
            // 다음 화면으로 전환
            self?.viewModel?.input.viewWillDisappear.accept(())
        }
    }
    
    public func bindInput(to viewModel: LaunchScreenViewModel) {
        let input = viewModel.input
        
    
    }
    
    public func bindOutput(from viewModel: LaunchScreenViewModel) {
        let output = viewModel.output
        
    }
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
