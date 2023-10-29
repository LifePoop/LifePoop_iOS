//
//  StoolLogRepository.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/09/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol StoolLogRepository {
    func fetchUserStoolLogs(accessToken: String, userID: Int) -> Single<[StoolLogEntity]>
    func fetchUserStoolLogs(accessToken: String, userID: Int, date: String) -> Single<[StoolLogEntity]>
    func postStoolLog(accessToken: String, stoolLogEntity: StoolLogEntity) -> Single<StoolLogEntity>
}
