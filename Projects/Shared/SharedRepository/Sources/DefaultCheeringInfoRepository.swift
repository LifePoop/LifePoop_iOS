//
//  DefaultCheeringInfoRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import SharedUseCase
import Utils

public final class DefaultCheeringInfoRepository: CheeringInfoRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var cheeringInfoEntityMapper: AnyDataMapper<CheeringInfoDTO, CheeringInfoEntity>
    
    public init() { }
    
    public func fetchUserCheeringInfo(accessToken: String, userID: Int, date: String) -> Single<CheeringInfoEntity> {
        return urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchCheeringInfo(
                accessToken: accessToken,
                userID: userID,
                date: date
            ))
            .decodeMap(CheeringInfoDTO.self)
            .transformMap(cheeringInfoEntityMapper)
    }
}
