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
    
    public func requestCheering(accessToken: String, userId: Int) -> Single<Bool> {
        urlSessionEndpointService
            .fetchStatusCode(endpoint: LifePoopLocalTarget.cheerFriend(
                accessToken: accessToken,
                userID: userId
            ))
            .map { statusCode in
                switch statusCode {
                case 201:
                    return true
                case 200, 202...299: // 201을 제외한 200번대 응답에 대해서..?
                    return false
                case 444:
                    throw NetworkError.invalidAccessToken
                default:
                    throw NetworkError.invalidStatusCode(code: statusCode)
                }
            }
    }
}
