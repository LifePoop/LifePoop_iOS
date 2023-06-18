//
//  ReportRepository.swift
//  FeatureReportUseCase
//
//  Created by 김상혁 on 2023/06/17.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxSwift

import CoreEntity

public protocol ReportRepository {
    func fetchAllUserStoolReports() -> Single<[StoolReport]>
}
