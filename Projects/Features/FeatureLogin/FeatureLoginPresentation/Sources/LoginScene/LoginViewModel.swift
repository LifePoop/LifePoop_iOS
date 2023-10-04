//
//  LoginViewModel.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureLoginCoordinatorInterface
import FeatureLoginDIContainer
import FeatureLoginUseCase
import Logger
import Utils

public final class LoginViewModel: ViewModelType {
    
    public struct Input {
        let didTapKakaoLoginButton = PublishRelay<Void>()
        let didTapAppleLoginButton = PublishRelay<Void>()
        let didChangeBannerImageIndex = BehaviorRelay<Int>(value: 0)
    }
    
    public struct Output {
        let bannerImages = BehaviorRelay<[Data]>(value: [])
        let subLabelText = BehaviorRelay<String>(value: "")
        let showErrorMessage = PublishRelay<String>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private let subLabelTexts = [
        LocalizableString.logYourStools,
        LocalizableString.cheerForEachOthersPoops,
        LocalizableString.shareYourBowelMovements
    ]
    
    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        let fetchKakaoToken = input.didTapKakaoLoginButton
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                `self`.loginUseCase.fetchOAuthAccessToken(for: .kakao)
            }
            .share()
        
        fetchKakaoToken
            .compactMap { $0.element }
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { `self`, oAuthTokenInfo in
                self.loginUseCase.requestLogin(with: oAuthTokenInfo)
                    .map { (oAuthTokenInfo: oAuthTokenInfo, isSuccess: $0 ) }
            }
            .bind(onNext: { oAuthTokenInfo, isSuccess in
                if isSuccess {
                    coordinator?.coordinate(by: .shouldFinishLoginFlow)
                } else {
                    coordinator?.coordinate(
                        by: .didTapKakaoLoginButton(userAuthInfo: oAuthTokenInfo)
                    )
                }
            })
            .disposed(by: disposeBag)
        
        fetchKakaoToken
            .compactMap { $0.error }
            .map { $0.localizedDescription }
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let fetchAppleToken = input.didTapAppleLoginButton
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                `self`.loginUseCase.fetchOAuthAccessToken(for: .apple)
            }
            .share()
        
        fetchAppleToken
            .compactMap { $0.element }
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { `self`, oAuthTokenInfo in
                self.loginUseCase.requestLogin(with: oAuthTokenInfo)
                    .map { (oAuthTokenInfo: oAuthTokenInfo, isSuccess: $0 ) }
            }
            .bind(onNext: { oAuthTokenInfo, isSuccess in
                if isSuccess {
                    coordinator?.coordinate(by: .shouldFinishLoginFlow)
                } else {
                    coordinator?.coordinate(
                        by: .didTapAppleLoginButton(userAuthInfo: oAuthTokenInfo)
                    )
                }
            })
            .disposed(by: disposeBag)
        
        fetchAppleToken
            .compactMap { $0.error }
            .map { $0.localizedDescription }
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
   
        input.didChangeBannerImageIndex
            .withUnretained(self)
            .filter { `self`, index in
                index < self.subLabelTexts.count
            }
            .map { `self`, index in
                self.subLabelTexts[index]
            }
            .bind(to: output.subLabelText)
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
