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
    
    public var invitationCode: Observable<String> {
        userInfoUseCase.userInfo
            .map { $0?.invitationCode ?? "" }
            .asObservable()
    }
    
    public init() { }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        friendListRepository
            .fetchFriendList()
            .asObservable()
    }
    
    public func requestAddingFriend(with invitationCode: String) -> Observable<Bool> {
        userInfoUseCase.userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                self.friendListRepository.requestAddingFriend(
                    with: invitationCode,
                    accessToken: accessToken
                )
                .retry(when: { errorStream in
                    errorStream.flatMap { _ in
                        self.retryWhenAccessTokenIsInvalid(invitationCode: invitationCode)
                    }
                })
            }
            .asObservable()
    }
    
    private func retryWhenAccessTokenIsInvalid(invitationCode: String) -> Observable<Bool> {
        let originalAuthInfo = userInfoUseCase.userInfo.compactMap { $0?.authInfo }
      
        Logger.log(
            message: "액세스 토큰 업데이트 후 재요청",
            category: .authentication,
            type: .debug
        )

        return originalAuthInfo
            .withUnretained(self)
            .flatMap {`self`, authInfo in
                self.userInfoUseCase.refreshAuthInfo(with: authInfo)
            }
            .catchAndReturn(false)
            .withUnretained(self)
            .flatMap { `self`, isSuccess -> Observable<Bool> in
                guard isSuccess else { return .just(false) }
                return self.requestAddingFriend(with: invitationCode)
            }
    }
}
