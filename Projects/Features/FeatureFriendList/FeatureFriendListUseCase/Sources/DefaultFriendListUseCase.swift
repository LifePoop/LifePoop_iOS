
//
//  DefaultFriendListUseCase.swift
//  FeatureFriendListUseCase
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import FeatureFriendListDIContainer
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultFriendListUseCase: FriendListUseCase {
    
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    @Inject(FriendListDIContainer.shared) private var friendListRepository: FriendListRepository
    
    public init() { }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        friendListRepository
            .fetchFriendList()
            .asObservable()
    }
    
    public func sendInvitationCode(_ invitationCode: String) -> Observable<Bool> {
        userInfoUseCase.userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                self.friendListRepository.sendInvitationCode(invitationCode, accessToken: accessToken)
            }
            .logErrorIfDetected(category: .network, type: .error)
            .map { result -> Bool in
                switch result {
                case .success(let isSuccess):
                    return isSuccess
                case .failure:
                    return false
                }
            }
            .asObservable()
    }
}
