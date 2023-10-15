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
    
    public override init() { }
    
    public func fetchFriendList() -> Single<[FriendEntity]> {
        Single.just(FriendEntity.dummyData)
    }
    
    public func sendInvitationCode(_ invitationCode: String, accessToken: String) -> Single<Result<Bool, Error>> {
        urlSessionEndpointService
            .fetchStatusCode(endpoint: LifePoopLocalTarget
                .sendInvitationCode(
                    code: invitationCode,
                    accessToken: accessToken
                ))
            .map { statusCode -> Result<Bool, Error> in
                switch statusCode {
                case 201:
                    return .success(true)
                case 444:
                    return .failure(NetworkError.invalidAccessToken)
                default:
                    return .failure(NetworkError.invalidStatusCode(code: statusCode))
                }
            }
            .catch { error in
                return .just(.failure(error))
            }
    }
}
