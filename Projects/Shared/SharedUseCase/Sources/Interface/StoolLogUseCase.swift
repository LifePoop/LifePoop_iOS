//
//  StoolLogUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/09/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol StoolLogUseCase {
    func fetchMyLast7DaysStoolLogs() -> Observable<[StoolLogEntity]>
    func fetchAllUserStoolLogs(userID: Int) -> Observable<[StoolLogEntity]>
    func fetchUserStoolLogs(userID: Int, date: String) -> Observable<[StoolLogEntity]>
    func postStoolLog(stoolLogEntity: StoolLogEntity) -> Observable<StoolLogEntity>
    func convertToStoolLogItems(from stoolLogsEntities: [StoolLogEntity]) -> [StoolLogItem]
}
