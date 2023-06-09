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
    
    func fetchFriendList() -> Observable<[FriendEntity]>
}
