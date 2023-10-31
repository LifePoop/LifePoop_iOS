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
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultReportUseCase: ReportUseCase {
    
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    @Inject(SharedDIContainer.shared) private var stoolLogUseCase: StoolLogUseCase
    
    public init() { }
    
    public func fetchAllUserStoolReports() -> Observable<[StoolReport]> {
        return userInfoUseCase
            .userInfo
            .compactMap { $0?.userId }
            .withUnretained(self)
            .flatMapLatest { `self`, userId in
                return self.stoolLogUseCase.fetchAllUserStoolLogs(userID: userId)
            }
            .withUnretained(self)
            .map { `self`, stoolLogs in
                self.convertToStoolReports(from: stoolLogs)
            }
            .logErrorIfDetected(category: .network)
    }
    
    public func fetchUserNickname() -> Observable<String> {
        return userInfoUseCase
            .userInfo
            .compactMap { $0?.nickname }
            .logErrorIfDetected(category: .network)
    }
}

// MARK: - Supporting Methods

private extension DefaultReportUseCase {
    
    func filter(stoolLogs: [StoolLogEntity], by period: ReportPeriod) -> [StoolLogEntity] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate = calendar.date(
            byAdding: .day,
            value: -period.days,
            to: calendar.startOfDay(for: now)
        ) ?? .now
        
        return stoolLogs.filter { startDate <= $0.date }
    }
    
    // TODO: 시간복잡도 낮추고 코드 함수화하여 간결하게 작성할 필요
    func convertToStoolReports(from stoolLogs: [StoolLogEntity]) -> [StoolReport] {
        var reports: [StoolReport] = []
        
        for period in ReportPeriod.allCases {
            let filteredStoolLogs = filter(stoolLogs: stoolLogs, by: period)
            let totalStoolCount = filteredStoolLogs.count
            let totalSatisfaction = filteredStoolLogs.filter { $0.isSatisfied }.count
            
            var colorCountMap: [StoolColor: Int] = [:]
            for color in StoolColor.allCases {
                let count = filteredStoolLogs.filter { $0.color == color }.count
                colorCountMap[color] = count
            }
            
            var shapeCountMap: [StoolShape: Int] = [:]
            for shape in StoolShape.allCases {
                let count = filteredStoolLogs.filter { $0.shape == shape }.count
                shapeCountMap[shape] = count
            }
            
            var shapeSizeCountMap: [StoolShapeSize: Int] = [:]
            for shape in StoolShape.allCases {
                for size in StoolSize.allCases {
                    let count = filteredStoolLogs.filter { $0.shape == shape && $0.size == size }.count
                    let shapeSize = StoolShapeSize(shape: shape, size: size)
                    shapeSizeCountMap[shapeSize] = count
                }
            }
            
            let report = StoolReport(
                period: period,
                totalStoolCount: totalStoolCount,
                totalSatisfaction: totalSatisfaction,
                totalStoolColorCountMap: colorCountMap,
                totalStoolShapeCountMap: shapeCountMap,
                totalStoolSizeCountMap: shapeSizeCountMap
            )
            
            reports.append(report)
        }
        
        return reports
    }
}
