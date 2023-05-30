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
    
    private func hasAccessToken() async -> Bool {
        if let authInfo = try? await getObjectFromKeyChain(asTypeOf: UserAuthInfo.self, forKey: .userAuthInfo) {
            // TODO: 앱 재기동했을 때 로그인 과정 확인하기 위한 임시처리
            try? await self.removeObjectFromKeyChain(authInfo, forKey: .userAuthInfo)
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
            .bind(onNext: { `self`, hasToken in
                Task {
                    let hasToken = await self.hasAccessToken()
                    if hasToken {
                        coordinator?.coordinate(by: .shouldFinishLoginFlow)
                    } else {
                        coordinator?.coordinate(by: .shouldShowLoginScene)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
