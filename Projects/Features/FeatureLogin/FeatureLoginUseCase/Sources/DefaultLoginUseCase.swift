//
//  DefaultLoginUseCase.swift
//  FeatureLoginUseCase
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity
import FeatureLoginDIContainer
import Logger
import Utils

public final class DefaultLoginUseCase: LoginUseCase {
    
    @Inject(LoginDIContainer.shared) private var loginRepository: LoginRepository
    
    public init() { }
    
    public func fetchKakaoAuthToken() -> Single<KakaoAuthResultEntity> {
        return loginRepository.fetchKakaoAuthToken()
    }
    
    public func fetchAppleAuthToken() -> Single<AppleAuthResultEntity> {
        return loginRepository.fetchAppleAuthToken().catchAndReturn(.init(identityToken: "nil"))

    }
}
