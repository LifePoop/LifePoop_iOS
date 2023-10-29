//
//  DefaultFriendListUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/10/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import Logger
import SharedDIContainer
import Utils

public final class DefaultFriendListUseCase: FriendListUseCase {
    
    @Inject(SharedDIContainer.shared) private var friendListRepository: FriendListRepository
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    
    public init() { }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        return friendListRepository.fetchFriendList().asObservable()
    }
}
