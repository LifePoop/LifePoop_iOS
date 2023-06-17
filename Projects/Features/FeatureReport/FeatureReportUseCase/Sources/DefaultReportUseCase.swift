//
//  DefaultReportUseCase.swift
//  FeatureReportUseCase
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import FeatureReportDIContainer
import Logger
import Utils

public final class DefaultReportUseCase: ReportUseCase {
    
    @Inject(ReportDIContainer.shared) private var reportRepository: ReportRepository
    
    public init() { }
    
    public func fetchAllUserStoolReports() ->  Observable<[StoolReport]> {
        return reportRepository
            .fetchAllUserStoolReports()
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
}
