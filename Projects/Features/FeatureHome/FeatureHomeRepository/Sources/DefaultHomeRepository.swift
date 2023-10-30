//
//  DefaultHomeRepository.swift
//  FeatureHomeRepository
//
//  Created by 김상혁 on 2023/10/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureHomeUseCase
import Logger
import Utils

public final class DefaultHomeRepository: HomeRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var friendEntityMapper: AnyDataMapper<FriendDTO, FriendEntity>
    
    public init() { }
    
    public func fetchFriendList(accessToken: String) -> Single<[FriendEntity]> {
        urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchFriendList(
                accessToken: accessToken
            ))
            .decodeMap([FriendDTO].self)
            .transformMap(friendEntityMapper)
    }
}
