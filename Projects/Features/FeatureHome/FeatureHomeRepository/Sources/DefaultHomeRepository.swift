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
    
    public init() { }
    
    public func fetchFriendList() -> Single<[FriendEntity]> {
        return Single.just(FriendEntity.dummyData)
    }
    
    public func fetchStoolLogs() -> Single<[StoolLogEntity]> {
        return Single.just(StoolLogEntity.dummyData)
    }
    
    public func fetchStoolLogsOfSelectedFriend(_ friend: FriendEntity) -> Single<[StoolLogEntity]> {
        return Single.just(StoolLogEntity.dummyData)
    }
}
