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
    
    private let mainLogoImageView = UIImageView(image: ImageAsset.logoLarge.image)
    
    private let mainCharacterImageView = UIImageView(image: ImageAsset.characterLarge.image)
    
    private let kakaoTalkLoginButon = LoginButton(
        title: "카카오로 계속하기",
        backgroundColor: ColorAsset.kakaoYellow.color,
        fontColor: ColorAsset.kakaoBrown.color,
        iconImage: ImageAsset.iconKakao.image
    )
    
    private let appleLoginButton = LoginButton(
        title: "Apple로 계속하기",
        backgroundColor: ColorAsset.black.color,
        fontColor: ColorAsset.white.color,
        iconImage: ImageAsset.iconApple.image
    )
    
    public var viewModel: LoginViewModel?
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    public func bindInput(to viewModel: LoginViewModel) {
        let input = viewModel.input
        
        kakaoTalkLoginButon.rx.tap
            .bind(to: input.didTapKakaoLoginButton)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .bind(to: input.didTapAppleLoginButton)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: LoginViewModel) {
        let output = viewModel.output
    }
}

// MARK: - UI Configuration

private extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension LoginViewController {
    func layoutUI() {
        let frameHeight = view.frame.height
        let frameWidth = view.frame.width

        view.addSubview(mainLogoImageView)
        view.addSubview(mainCharacterImageView)
        view.addSubview(kakaoTalkLoginButon)
        view.addSubview(appleLoginButton)

        mainLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(frameHeight*0.22)
        }
        
        mainCharacterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(frameHeight*0.38)
        }
        
        kakaoTalkLoginButon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainCharacterImageView.snp.bottom).offset(frameHeight*0.14)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(kakaoTalkLoginButon.snp.bottom).offset(frameHeight*0.01)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
    }
}
