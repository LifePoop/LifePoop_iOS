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
import Utils

public final class LoginViewModel: ViewModelType {
    
    public struct Input {
        let didTapKakaoLoginButton = PublishRelay<Void>()
        let didTapAppleLoginButton = PublishRelay<Void>()
    }
    
    public struct Output {
        let bannerImages = BehaviorRelay<[Data]>(value: [])
        let errorDidOccur = PublishRelay<Error>()
    }
    
    public let input = Input()
    public let output = Output()
    
    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - nextButtonDidTap
        input.didTapKakaoLoginButton
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.loginUseCase.fetchKakaoAuthToken() }
            .subscribe(with: self, onNext: { `self`, result in
                coordinator?.coordinate(by: .didTapKakaoLoginButton)
            }, onError: { `self`, error in
                self.output.errorDidOccur.accept(error)
            })
            .disposed(by: disposeBag)
        
        input.didTapAppleLoginButton
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.loginUseCase.fetchAppleAuthToken() }
            .subscribe(with: self, onNext: { `self`, result in
                coordinator?.coordinate(by: .didTapAppleLoginButton)
            }, onError: { `self`, error in
                self.output.errorDidOccur.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
