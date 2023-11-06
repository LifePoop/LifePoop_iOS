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

public enum InvitationError: Error {
    
    case alreadyAddedFriend
    case nonExistingCode
    case invalidResult
}

public protocol FriendListUseCase {
    var invitationCode: Observable<String> { get }
    func fetchFriendList() -> Observable<[FriendEntity]>
    func requestAddingFriend(with invitationCode: String) -> Observable<Bool>
    func checkInvitationCodeValidation(_ invitationCode: String) -> Observable<InvitationCodeInputStatus>
}
