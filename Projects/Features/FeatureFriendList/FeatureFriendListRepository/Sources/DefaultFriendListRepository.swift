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
    
    public func requestAddingFriend(
        with invitationCode: String,
        accessToken: String
    ) -> Single<Result<Bool, InvitationError>> {
        urlSessionEndpointService
            .fetchStatusCode(endpoint: LifePoopLocalTarget
                .sendInvitationCode(
                    code: invitationCode,
                    accessToken: accessToken
                ))
            .map { statusCode in
                switch statusCode {
                case 201:
                    return .success(true)
                case 400:
                    return .failure(.invalidResult)
                case 404:
                    return .failure(.nonExistingCode)
                case 409:
                    return .failure(.alreadyAddedFriend)
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

                    throw NetworkError.invalidStatusCode(code: statusCode)
                }
            }
    }
}
