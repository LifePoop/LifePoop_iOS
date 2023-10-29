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
//                .retry(when: { errorObservable in
//                    errorObservable.flatMap { error in
//                        if let error = error as? NetworkError, case .invalidAccessToken = error {
//                            //1. 키체인에서 refreshToken 가져옴
//                            return self.keyChainRepository.fetchRefreshToken
//                                .flatMap {
//                                    //2. 가져온걸로 새로운 token 요청
//                                    self.urlSessionEndpointService
//                                        .fetchData(endpoint: LifePoopLocalTarget.refresh(refreshToken: $0))
//                                }
//                                .flatMap {
//                                    //3. 키체인 갱신
//                                    self.keyChainRepository
//                                        .saveToken($0)
//                                }
//                            // 얘가 subscribe가 안됐는데 실행이 되나..?
//                        }
//                    }
//                })
                .decodeMap(StoolLogDTO.self)
                .do(onSuccess: {
                    dump($0)
                })
                .transformMap(self.stoolLogEntityMapper)
        }
    }
    
    public func fetchUserStoolLogs(accessToken: String, userID: Int) -> Single<[StoolLogEntity]> {
//        return .error(NetworkError.invalidResponse)
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
