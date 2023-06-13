//
//  ReportUseCase.swift
//  FeatureReportUseCase
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol ReportUseCase {
    func fetchUserStoolReport(of period: ReportPeriod) -> Observable<StoolReport>
}
