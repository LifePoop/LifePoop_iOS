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
    @Inject(CoreDIContainer.shared) private var stoolLogEntityMapper: AnyDataMapper<StoolLogDTO, StoolLogEntity>
    @Inject(CoreDIContainer.shared) private var stoolLogDTOMapper: AnyDataMapper<StoolLogEntity, StoolLogDTO>
    
    public init() { }
    
    public func fetchFriendList() -> Single<[FriendEntity]> {
        return Single.just(FriendEntity.dummyData)
    }
    
    public func fetchStoolLogs(of userID: Int) -> Single<[StoolLogEntity]> {
        return urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchStoolLog(userID: userID))
            .decodeMap([StoolLogDTO].self)
            .transformMap(stoolLogEntityMapper)
    }
    
    public func fetchStoolLogsOfSelectedFriend(_ friend: FriendEntity) -> Single<[StoolLogEntity]> {
        return Single.just(StoolLogEntity.dummyData)
    }
    
    public func postStoolLog(_ stoolLogEntity: StoolLogEntity, accessToken: String) -> Single<StoolLogEntity> {
        return Single.deferred { [weak self] in
            guard let self else { return .error(NetworkError.objectDeallocated) }
            let stoolLogDTO = try self.stoolLogDTOMapper.transform(stoolLogEntity)
            return self.urlSessionEndpointService
                .fetchData(endpoint: LifePoopLocalTarget.postStoolLog(accessToken: accessToken), with: stoolLogDTO)
                .decodeMap(StoolLogDTO.self)
                .transformMap(self.stoolLogEntityMapper)
        }
    }
}
