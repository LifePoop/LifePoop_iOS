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
        
        // MARK: 앱 설치 후 최초 기동 시에 기존 사용자 정보 삭제
        let preparationResult = input.viewWillAppear
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, _ in
                self.loginUseCase.clearUserAuthInfoIfLaunchedFirstly()
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
        
        // MARK: LaunchScreen 애니메이션 처리 및 부가 작업 끝나면 자동 로그인 시도
        Observable.zip(
            input.didFinishAnimating,
            input.didFinishPreparation
        )
        .withUnretained(self)
        .flatMapLatest { $0.0.loginUseCase.requestAutoLoginWithExistingUserInfo() }
        .asObservable()
        .bind(onNext: { hasToken in
            if hasToken {
                coordinator?.coordinate(by: .skipLoginFlow)
            } else {
                coordinator?.coordinate(by: .showLoginScene)
            }
        })
        .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
