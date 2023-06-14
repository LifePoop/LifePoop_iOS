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
import Utils

public final class DefaultFriendListUseCase: FriendListUseCase {
    
    @Inject(FriendListDIContainer.shared) private var friendListRepository: FriendListRepository
    
    public init() { }
    
    public func fetchFriendList() -> Observable<[FriendEntity]> {
        friendListRepository
            .fetchFriendList()
            .asObservable()
    }
}
