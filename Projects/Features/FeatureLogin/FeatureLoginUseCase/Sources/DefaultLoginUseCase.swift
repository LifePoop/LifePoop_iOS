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
        return loginRepository.fetchAccessToken(for: .kakao)
            .asObservable()
            .compactMap { $0 as? KakaoAuthResultEntity }
            .asSingle()
            .logErrorIfDetected(category: .authentication)
    }
    
    public func fetchAppleAuthToken() -> Single<AppleAuthResultEntity> {
        return loginRepository.fetchAccessToken(for: .apple)
            .asObservable()
            .compactMap { $0 as? AppleAuthResultEntity }
            .asSingle()
            .logErrorIfDetected(category: .authentication)
    }
}
