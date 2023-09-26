//
//  DefaultSignupRepository.swift
//  FeatureLoginRepository
//
//  Created by Lee, Joon Woo on 2023/09/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation
import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureLoginUseCase
import Utils

public final class DefaultSignupRepository: NSObject, SignupRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    
    public override init() { }
    
    public func requestSignup(with signupInfo: SignupInput) -> Single<Bool> {
        return urlSessionEndpointService
            .fetchStatusCode(
                endpoint: LifePoopLocalTarget.signup(provider: signupInfo.provider.description),
                with: [
                    "nickname": signupInfo.nickname,
                    "birth": signupInfo.birthDate,
                    "sex": signupInfo.gender.description,
                    "oAuthAccessToken": signupInfo.oAuthAccessToken
                ]
            )
            .asObservable()
            .map { $0 >= 200 && $0 < 300 }
            .catchAndReturn(false)
            .asSingle()
    }
}
