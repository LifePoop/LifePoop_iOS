//
//  DefaultFriendListRepository.swift
//  FeatureFriendListRepository
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import FeatureFriendListUseCase

public final class DefaultFriendListRepository: NSObject, FriendListRepository {
    
    public override init() { }
    
    public func fetchFriendList() -> Single<[FriendEntity]> {
        Single.just(FriendEntity.dummyData)
    }
}
