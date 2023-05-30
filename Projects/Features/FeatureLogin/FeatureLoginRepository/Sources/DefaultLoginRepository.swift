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
    
    public func fetchAccessToken(for loginType: LoginType) -> Single<AccessTokenPossessable> {
        
        authManager(for: loginType).fetchToken()
            .do(onSuccess: { [weak self] in
                let authInfo = UserAuthInfo(loginType: loginType, authToken: $0)
                self?.saveAuthInfoInKeyChain(authInfo, forKey: .userAuthInfo)
            })
    }
}

extension DefaultLoginRepository: KeyChainManagable {
    
    @discardableResult
    private func saveAuthInfoInKeyChain(_ authInfo: UserAuthInfo, forKey key: ItemKey) -> Bool {
        do {
            try saveObject(authInfo, forKey: .userAuthInfo)
            return true
        } catch {
            return false
        }
    }
}
