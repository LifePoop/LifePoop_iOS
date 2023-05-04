//
//  DefaultHomeRepository.swift
//  FeatureHomeRepository
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureHomeUseCase
import Utils

public final class DefaultHomeRepository: HomeRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var coreExampleDataMapper: AnyDataMapper<CoreExampleDTO, CoreExampleEntity>
    
    public init() { }
    
    public func fetchFriendList() -> Single<CoreExampleEntity> {
        return urlSessionEndpointService.fetchData(
            endpoint: LifePoopTarget.fetchAccessToken(
                clientID: "exampleID",
                clientSecret: "exampleSecret",
                tempCode: "exampleTestCode"
            )
        )
        .decodeMap(CoreExampleDTO.self)
        .transformMap(coreExampleDataMapper)
    }
}
