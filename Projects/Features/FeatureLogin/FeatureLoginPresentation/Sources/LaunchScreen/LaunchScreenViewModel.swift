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
import SharedDIContainer
import SharedUseCase
import Utils

public final class LaunchScreenViewModel: ViewModelType {
    
    public struct Input {
        let viewWillAppear = PublishRelay<Void>()
        let didFinishPreparation = PublishRelay<Void>()
        let didFinishAnimating = PublishRelay<Void>()
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
                print("\(error) 확인 -> 추후 확인 후 토스트 메시지 혹은 다른 시각적 요소 출력으로 대체")
            })
            .disposed(by: disposeBag)
        
        Observable.zip(
            input.didFinishAnimating,
            input.didFinishPreparation
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .withUnretained(self)
        .flatMapLatest { `self`, _ in
            self.userInfoUseCase.userInfo
                .map { $0 != nil }
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
