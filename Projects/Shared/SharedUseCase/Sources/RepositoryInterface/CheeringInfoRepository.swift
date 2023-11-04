//
//  CheeringInfoRepository.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol CheeringInfoRepository {
    func fetchUserCheeringInfo(accessToken: String, userID: Int, date: String) -> Single<CheeringInfoEntity>
    func requestCheering(accessToken: String, userId: Int) -> Single<Bool>
}
