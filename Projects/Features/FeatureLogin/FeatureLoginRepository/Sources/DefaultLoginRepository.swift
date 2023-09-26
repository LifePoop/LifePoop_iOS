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
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    
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
        authManager(for: loginType).fetchAccessToken()
    }
    
    public func requestSignin(with userAuthInfo: UserAuthInfoEntity) -> Single<Bool> {
        guard let loginType = userAuthInfo.loginType else { return Single.just(false) }
        
        return urlSessionEndpointService
            .fetchStatusCode(
                endpoint: LifePoopLocalTarget.login(
                    provider: loginType.description
                ),
                with: ["oAuthAccessToken": userAuthInfo.accessToken]
            )
            .asObservable()
            .map { $0 >= 200 && $0 < 300 }
            .catchAndReturn(false)
            .asSingle()
    }
}
