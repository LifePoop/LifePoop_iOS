//
//  MockReportRepository.swift
//  FeatureReportRepository
//
//  Created by 김상혁 on 2023/06/17.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import FeatureReportUseCase
import Utils

public final class MockReportRepository: ReportRepository {
    
    public init() { }
    
    public func fetchAllUserStoolReports() -> Single<[StoolReport]> {
        return .just([
            StoolReport.weekStoolReportDummyData,
            StoolReport.monthStoolReportDummyData,
            StoolReport.threeMonthsStoolReportDummyData,
            StoolReport.yearStoolReportDummyData
        ])
    }
}
