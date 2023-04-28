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
import FeatureLoginDIContainer
import FeatureLoginUseCase
import Utils

public final class LoginViewModel: ViewModelType {
    
    public struct Input {
        let nextButtonDidTap = PublishRelay<Void>()
        let fetchAccessTokenButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let accessToken = BehaviorRelay<String>(value: "")
        let showToastMessage = PublishRelay<String>()
    }
    
    public let input = Input()
    public let output = Output()
    
    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - nextButtonDidTap
        
        input.nextButtonDidTap
            .bind {
                coordinator?.coordinate(by: .nextButtonDidTap)
            }
            .disposed(by: disposeBag)
        
        let fetchedAccessToken = input.fetchAccessTokenButtonDidTap
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.loginUseCase.fetchAccessToken()
            }
            .share()
        
        fetchedAccessToken
            .compactMap { $0.element }
            .map { $0.name }
            .bind(to: output.accessToken)
            .disposed(by: disposeBag)
        
        fetchedAccessToken
            .compactMap { $0.error }
            .toastMeessageMap(to: .failToFetchAccessToken)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
    }
}
