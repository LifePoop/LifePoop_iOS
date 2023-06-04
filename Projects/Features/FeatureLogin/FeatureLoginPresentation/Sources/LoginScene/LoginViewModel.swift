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
        
        input.didTapKakaoLoginButton
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                `self`.loginUseCase
                    .fetchKakaoAuthToken()
                    .catch { error in
                        self.output.errorDidOccur.accept(error)
                        return Single.just(nil)
                    }
            }
            .filter { $0 != nil }
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .didTapKakaoLoginButton)
            })
            .disposed(by: disposeBag)
        
        input.didTapAppleLoginButton
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                `self`.loginUseCase
                    .fetchAppleAuthToken()
                    .catch { error in
                        self.output.errorDidOccur.accept(error)
                        return Single.just(nil)
                    }
            }
            .filter { $0 != nil }
            .bind(onNext: { _ in
                coordinator?.coordinate(by: .didTapAppleLoginButton)
            })
            .disposed(by: disposeBag)
    }
}
