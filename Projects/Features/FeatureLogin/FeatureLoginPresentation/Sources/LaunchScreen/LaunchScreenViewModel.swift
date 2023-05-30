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
import Utils

public final class LaunchScreenViewModel: ViewModelType, KeyChainManagable {
    
    public struct Input {
        let viewWillDisappear = PublishRelay<Void>()
    }
    
    public struct Output {

    }
    
    public let input = Input()
    public let output = Output()
    
    private var hasAccessToekn: Bool {
        if let _ = try? getObject(asTypeOf: UserAuthInfo.self, forKey: .userAuthInfo) {
            return true
        } else {
            return false
        }
    }
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        input.viewWillDisappear
            .withUnretained(self)
            .compactMap { $0.0.hasAccessToekn }
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
