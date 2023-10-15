//
//  FriendListUseCase.swift
//  FeatureFriendListUseCase
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol FriendListUseCase {
    
    var invitationCode: Observable<String> { get }
    func fetchFriendList() -> Observable<[FriendEntity]>
    func requestAddingFriend(with invitationCode: String) -> Observable<Bool>
}
