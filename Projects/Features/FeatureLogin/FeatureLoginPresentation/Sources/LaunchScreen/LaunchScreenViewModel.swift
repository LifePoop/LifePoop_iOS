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
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class LaunchScreenViewModel: ViewModelType {
    
    public struct Input {
        let viewWillAppear = PublishRelay<Void>()
        let didFinishPreparation = PublishRelay<Void>()
    }
    
    public struct Output { }
    
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    
    public let input = Input()
    public let output = Output()
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        let preparationResult = input.viewWillAppear
            .withUnretained(self)
            .flatMapCompletableMaterialized {  `self`, _ in
                self.userInfoUseCase.clearUserAuthInfoIfNeeded()
            }
            .share()
        
        preparationResult
            .compactMap { $0.element }
            .bind(to: input.didFinishPreparation)
            .disposed(by: disposeBag)
        
        preparationResult
            .compactMap { $0.error }
            .bind(onNext: { error in
                Logger.log(message: error.localizedDescription, category: .authentication, type: .error)
            })
            .disposed(by: disposeBag)
        
        input.didFinishPreparation
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.userInfoUseCase.userInfo
                    .map { _ in true }
                    .catchAndReturn(false)
            }
            .bind(onNext: { hasToken in
                if hasToken {
                    coordinator?.coordinate(by: .shouldFinishLoginFlow)
                } else {
                    coordinator?.coordinate(by: .shouldShowLoginScene)
                }
            })
            .disposed(by: disposeBag)
    }
}
