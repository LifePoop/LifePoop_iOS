//
//  DefaultFriendListRepository.swift
//  FeatureFriendListRepository
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureFriendListUseCase
import Logger
import Utils

public final class DefaultFriendListRepository: NSObject, FriendListRepository {

    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var friendEntityMapper: AnyDataMapper<FriendDTO, FriendEntity>
    
    public override init() { }

    public func fetchFriendList(accessToken: String) -> Single<[FriendEntity]> {
        urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchFriendList(
                accessToken: accessToken
            ))
            .decodeMap([FriendDTO].self)
            .transformMap(friendEntityMapper)
    }
    
    // MARK: 서버팀에서 정의한 상태코드에 대해서만 우선 예외 던짐 처리
    public func requestAddingFriend(with invitationCode: String, accessToken: String) -> Single<Bool> {
        urlSessionEndpointService
            .fetchStatusCode(endpoint: LifePoopLocalTarget
                .sendInvitationCode(
                    code: invitationCode,
                    accessToken: accessToken
                ))
            .map { statusCode in
                switch statusCode {
                case 201:
                    return true
                case 444:
                    throw NetworkError.invalidAccessToken
                default:
                    Logger.log(
                        message: NetworkError.invalidStatusCode(
                            code: statusCode
                        )
                        .localizedDescription,
                        category: .network,
                        type: .error
                    )

                    return false
                }
            }
    }
}
