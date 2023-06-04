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
        let viewWillDisappear = PublishRelay<Void>()
    }
    
    public struct Output { }
    
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    
    public let input = Input()
    public let output = Output()
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        input.viewWillDisappear
            .debug()
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.hasAccessToken()
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
    
    private func hasAccessToken() -> Single<Bool> {
        userInfoUseCase.userInfo
            .map { _ in true }
            .catchAndReturn(false)
    }
}
