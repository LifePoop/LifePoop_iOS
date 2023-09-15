//
//  LaunchScreenViewModel.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/17.
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

public final class LaunchScreenViewModel: ViewModelType {
    
    public struct Input {
        let viewWillAppear = PublishRelay<Void>()
        let didFinishPreparation = PublishRelay<Void>()
        let didFinishAnimating = PublishRelay<Void>()
    }
    
    public struct Output { }

    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase

    public let input = Input()
    public let output = Output()
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        let preparationResult = input.viewWillAppear
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, _ in
                self.loginUseCase.clearUserAuthInfoIfNeeded()
            }
            .share()
        
        preparationResult
            .compactMap { $0.element }
            .bind(to: input.didFinishPreparation)
            .disposed(by: disposeBag)
        
        preparationResult
            .compactMap { $0.error }
            .bind(onNext: { error in
                print("\(error) 확인 -> 추후 확인 후 토스트 메시지 혹은 다른 시각적 요소 출력으로 대체")
            })
            .disposed(by: disposeBag)
        
        Observable.zip(
            input.didFinishAnimating,
            input.didFinishPreparation
        )
        .withUnretained(self)
        .flatMapLatest { `self`, _ in
            self.loginUseCase.userInfo
        }
        .withUnretained(self)
        .flatMapLatest { `self`, userInfo in
            // MARK: 기기에 인증 정보가 존재하면 유효성 검증 위해 자동으로 로그인 요청
            if let userAuthInfo = userInfo?.authInfo {
                return self.loginUseCase.requestSignin(with: userAuthInfo)
            } else {
                return Observable.just(false)
            }
        }
        .bind(onNext: { hasToken in
            if hasToken {
                coordinator?.coordinate(by: .shouldSkipLoginFlow)
            } else {
                coordinator?.coordinate(by: .shouldShowLoginScene)
            }
        })
        .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
