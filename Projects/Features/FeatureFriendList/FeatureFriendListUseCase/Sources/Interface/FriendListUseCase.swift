//
//  FriendListUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/10/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol FriendListUseCase {
    func fetchFriendList() -> Observable<[FriendEntity]>
    func requestAddingFriend(with invitationCode: String) -> Observable<Bool>
    var invitationCode: Observable<String> { get }
}
