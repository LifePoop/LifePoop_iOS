//
//  HomeRepository.swift
//  FeatureHomeUseCase
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity

public protocol HomeRepository {
    func fetchFriendList() -> Single<[FriendEntity]>
    func fetchStoolLogs() -> Single<[StoolLogEntity]>
}
