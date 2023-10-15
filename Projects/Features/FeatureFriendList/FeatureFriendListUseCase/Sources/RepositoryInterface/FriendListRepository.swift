//
//  FriendListRepository.swift
//  FeatureFriendListUseCase
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import Utils

public protocol FriendListRepository: AnyObject {
    
    func fetchFriendList(accessToken: String) -> Single<[FriendEntity]>
    func requestAddingFriend(
        with invitationCode: String,
        accessToken: String
    ) -> Single<Bool>
}
