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
    @Inject(SharedDIContainer.shared) private var storyFeedUseCase: StoryFeedUseCase
    
    public init() { }
    
    public var invitationCode: Observable<String> {
        userInfoUseCase.userInfo
            .map { $0?.invitationCode ?? "" }
            .asObservable()
    }
    
    public var userNickname: Observable<String> {
        userInfoUseCase.userInfo
            .map { $0?.nickname ?? "" }
    }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        userInfoUseCase.userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                self.friendListRepository.fetchFriendList(accessToken: accessToken)
                    .retry(when: { errorStream in
                        errorStream.take(1).flatMap { _ in
                            self.retryWhenAccessTokenIsInvalid()
                        }
                    })
            }
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
                    errorStream.take(1).flatMap { _ in
                        self.retryWhenAccessTokenIsInvalid(invitationCode: invitationCode)
                    }
                })
                .map { result in
                    switch result {
                    case .success(let isSuccess):
                        return isSuccess
                    case .failure(let error):
                        throw error
                    }
                }
            }
            .asObservable()
    }

    public func checkInvitationCodeValidation(_ input: String) -> Observable<InvitationCodeInputStatus> {
        Observable.combineLatest(
            checkInvitationCodeLengthValidation(input),
            checkInvitationCodeDuplication(input)
        )
        .map { isLengthValid, isDuplicate in
            switch (isLengthValid, isDuplicate) {
            case (true, false):
                return .validInput
            case (true, true):
                return .codeOfSelf
            case (false, false):
                return .invalidLength
            default:
                return .invalidLength
            }
        }
    }
    
    public func fetchStoryFeeds() -> Observable<[StoryFeedEntity]> {
        return storyFeedUseCase.fetchStoryFeeds()
    }
}

private extension DefaultFriendListUseCase {

    func requestRefreshingAuthInfo() -> Observable<(isSuccess: Bool, userAuthInfo: UserAuthInfoEntity?)> {
        let originalAuthInfo = userInfoUseCase.userInfo.compactMap { $0?.authInfo }
      
        Logger.log(
            message: "액세스 토큰 업데이트 후 재요청",
            category: .authentication,
            type: .debug
        )
        
        return originalAuthInfo
            .withUnretained(self)
            .flatMap {`self`, authInfo -> Observable<Bool> in
                self.userInfoUseCase.refreshAuthInfo(with: authInfo)
            }
            .withLatestFrom(userInfoUseCase.userInfo) { (isSuccess: $0, userAuthInfo: $1?.authInfo) }
    }
    
    func retryWhenAccessTokenIsInvalid(invitationCode: String) -> Observable<Bool> {
        requestRefreshingAuthInfo()
            .withUnretained(self)
            .flatMap { `self`, result -> Single<Bool> in
                guard result.isSuccess,
                      let updatedAuthInfo = result.userAuthInfo else {
                    return .just(false)
                }
                
                return self.friendListRepository.requestAddingFriend(
                    with: invitationCode,
                    accessToken: updatedAuthInfo.accessToken
                )
                .map { _ in false }
            }
            .asObservable()
    }
    
    func retryWhenAccessTokenIsInvalid() -> Observable<[FriendEntity]> {
        requestRefreshingAuthInfo()
            .withUnretained(self)
            .flatMap { `self`, result -> Single<[FriendEntity]> in
                guard result.isSuccess,
                      let updatedAuthInfo = result.userAuthInfo else {
                    return .just([])
                }
                
                return self.friendListRepository.fetchFriendList(
                    accessToken: updatedAuthInfo.accessToken
                )
            }
            .asObservable()
    }

    func checkInvitationCodeLengthValidation(_ input: String) -> Observable<Bool> {
        Observable.just(input.count == 8)
    }

    func checkInvitationCodeDuplication(_ input: String) -> Observable<Bool> {
        invitationCode.map { $0 == input }
    }
}
