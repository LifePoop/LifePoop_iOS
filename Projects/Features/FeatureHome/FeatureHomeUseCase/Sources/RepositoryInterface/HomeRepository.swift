//
//  HomeRepository.swift
//  FeatureHomeUseCase
//
//  Created by 김상혁 on 2023/10/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol HomeRepository {
    func fetchFriendList(accessToken: String) -> Single<[FriendEntity]>
}
