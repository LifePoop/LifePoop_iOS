//
//  DefaultLoginRepository.swift
//  FeatureLoginRepository
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureLoginUseCase
import Utils

public final class DefaultLoginRepository: LoginRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var coreExampleDataMapper: AnyDataMapper<CoreExampleDTO, CoreExampleEntity>
    
    public init() { }
    
    public func fetchAccessToken() -> Single<KakaoAuthResult> {
        Single.create { observer in
            
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: { token, error in
                    if let error = error {
                        observer(.failure(error))
                        return
                    }
                    
                    guard let token = token else { return }
                    let result = KakaoAuthResult(accessToken: token.accessToken, refreshToken: token.refreshToken)
                    observer(.success(result))
                })
            }
            
            return Disposables.create { }
        }
//        return urlSessionEndpointService.fetchData(
//            endpoint: LifePoopTarget.fetchAccessToken(
//                clientID: "exampleID",
//                clientSecret: "exampleSecret",
//                tempCode: "exampleTestCode"
//            )
//        )
//        .decodeMap(CoreExampleDTO.self)
//        .transformMap(coreExampleDataMapper)
    }
}
