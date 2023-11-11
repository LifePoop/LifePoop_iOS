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
    
    struct LoadingIndicatorTarget {
        let loginType: LoginType
        let activate: Bool
    }
    
    public struct Input {
        let didTapKakaoLoginButton = PublishRelay<Void>()
        let didTapAppleLoginButton = PublishRelay<Void>()
        let didChangeBannerImageIndex = BehaviorRelay<Int>(value: 0)
    }
    
    public struct Output {
        let bannerImages = BehaviorRelay<[Data]>(value: [])
        let subLabelText = BehaviorRelay<String>(value: "")
        let showErrorMessage = PublishRelay<String>()
        let showLoadingIndicator = PublishRelay<LoadingIndicatorTarget>()
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
            .do(onNext: { `self`, _ in
                self.output.showLoadingIndicator.accept(.init(loginType: .kakao, activate: true))
            })
            .flatMapMaterialized { `self`, _ in
                `self`.loginUseCase.fetchOAuthAccessToken(for: .kakao)
            }
            .do(onNext: { [weak self] _ in
                self?.output.showLoadingIndicator.accept(.init(loginType: .kakao, activate: false))
            })
            .share()
        
        fetchKakaoToken
            .compactMap { $0.element }
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { `self`, oAuthTokenInfo in
                self.loginUseCase.requestLogin(with: oAuthTokenInfo)
                    .map { (oAuthTokenInfo: oAuthTokenInfo, loginResult: $0 ) }
            }
            .bind(onNext: { [weak self] oAuthTokenInfo, loginResult in
                switch loginResult {
                case .success(let isSuccess):
                    isSuccess ? coordinator?.coordinate(by: .finishLoginFlow)
                              : coordinator?.coordinate(
                                    by: .didTapKakaoLoginButton(userAuthInfo: oAuthTokenInfo)
                                )
                case .failure(let error):
                    self?.output.showErrorMessage.accept(error.description)
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
            .do(onNext: { `self`, _ in
                self.output.showLoadingIndicator.accept(.init(loginType: .apple, activate: true))
            })
            .flatMapMaterialized { `self`, _ in
                `self`.loginUseCase.fetchOAuthAccessToken(for: .apple)
            }
            .do(onNext: { [weak self] _ in
                self?.output.showLoadingIndicator.accept(.init(loginType: .apple, activate: false))
            })
            .share()
        
        fetchAppleToken
            .compactMap { $0.element }
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { `self`, oAuthTokenInfo in
                self.loginUseCase.requestLogin(with: oAuthTokenInfo)
                    .map { (oAuthTokenInfo: oAuthTokenInfo, loginResult: $0 ) }
            }
            .bind(onNext: { [weak self] oAuthTokenInfo, loginResult in
                switch loginResult {
                case .success(let isSuccess):
                    isSuccess ? coordinator?.coordinate(by: .finishLoginFlow)
                              : coordinator?.coordinate(
                                    by: .didTapAppleLoginButton(userAuthInfo: oAuthTokenInfo)
                                )
                case .failure(let error):
                    self?.output.showErrorMessage.accept(error.description)
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
