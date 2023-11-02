//
//  DefaultUserProfileEditRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/11/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import SharedUseCase
import Utils

public final class DefaultUserProfileEditRepository: UserProfileEditRepository {

    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    @Inject(CoreDIContainer.shared) private var userProfileDTOMapper: AnyDataMapper<UserProfileEntity, UserProfileDTO>

    public init() { }

    public func editUserProfile(accessToken: String, userProfileEntity: UserProfileEntity) -> Completable {
        return Completable.deferred { [weak self] in
            guard let self else { return .error(NetworkError.objectDeallocated) }
            let userProfileDTO = try self.userProfileDTOMapper.transform(userProfileEntity)
            return self.urlSessionEndpointService
                .fetchStatusCode(
                    endpoint: LifePoopLocalTarget.editProfileInfo(accessToken: accessToken),
                    with: userProfileDTO
                )
                .asCompletableForStatusCode(expected: 200)
        }
    }
}
