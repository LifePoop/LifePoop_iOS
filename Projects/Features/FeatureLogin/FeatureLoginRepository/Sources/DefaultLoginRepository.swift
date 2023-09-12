//
//  DefaultLoginRepository.swift
//  FeatureLoginRepository
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//
import Foundation
import RxSwift

import CoreAuthentication
import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureLoginUseCase
import Utils

public final class DefaultLoginRepository: NSObject, LoginRepository {
    
    public override init() { }
    
    private func authManager(for loginType: LoginType) -> AuthManagable {
        switch loginType {
        case .apple:
            return AppleAuthManager()
        case .kakao:
            return KakaoAuthManager()
        }
    }
    
    public func fetchAccessToken(for loginType: LoginType) -> Single<String> {
        authManager(for: loginType).fetchToken()
    }
}
