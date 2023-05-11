//
//  LoginViewModel.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//
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
            .bind(onNext: {
                coordinator?.coordinate(by: .didTapKakaoLoginButton)
            })
            .disposed(by: disposeBag)
        
        input.didTapAppleLoginButton
            .bind(onNext: {
                coordinator?.coordinate(by: .didTapAppleLoginButton)
            })
            .disposed(by: disposeBag)
    }
}
