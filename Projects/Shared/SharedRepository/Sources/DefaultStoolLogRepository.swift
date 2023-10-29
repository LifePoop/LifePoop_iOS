//
//  DefaultStoolLogRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/09/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import SharedUseCase
import Utils

public final class DefaultStoolLogRepository: StoolLogRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var stoolLogEntityMapper: AnyDataMapper<StoolLogDTO, StoolLogEntity>
    @Inject(CoreDIContainer.shared) private var stoolLogDTOMapper: AnyDataMapper<StoolLogEntity, StoolLogDTO>
    
    public init() { }
    
    public func postStoolLog(accessToken: String, stoolLogEntity: StoolLogEntity) -> Single<StoolLogEntity> {
        return Single.deferred { [weak self] in
            guard let self else { return .error(NetworkError.objectDeallocated) }
            let stoolLogDTO = try self.stoolLogDTOMapper.transform(stoolLogEntity)
            return self.urlSessionEndpointService
                .fetchData(endpoint: LifePoopLocalTarget.postStoolLog(accessToken: accessToken), with: stoolLogDTO)
                .decodeMap(StoolLogDTO.self)
                .transformMap(self.stoolLogEntityMapper)
        }
    }
    
    public func fetchUserStoolLogs(accessToken: String, userID: Int) -> Single<[StoolLogEntity]> {
        return urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchStoolLog(
                accessToken: accessToken,
                userID: userID
            ))
            .decodeMap([StoolLogDTO].self)
            .transformMap(stoolLogEntityMapper)
    }
    
    public func fetchUserStoolLogs(accessToken: String, userID: Int, date: String) -> Single<[StoolLogEntity]> {
        return urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchStoolLogAtDate(
                accessToken: accessToken,
                userID: userID,
                date: date
            ))
            .decodeMap([StoolLogDTO].self)
            .transformMap(stoolLogEntityMapper)
    }
}
