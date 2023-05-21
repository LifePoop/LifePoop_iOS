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

public final class LaunchScreenViewModel: ViewModelType {
    
    public struct Input {
        let viewWillDisappear = PublishRelay<Void>()
    }
    
    public struct Output {

    }
    
    public let input = Input()
    public let output = Output()
    
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - nextButtonDidTap
        input.viewWillDisappear
            .bind(onNext: {
                coordinator?.coordinate(by: .shouldShowLoginScene)
            })
            .disposed(by: disposeBag)

    }
}
