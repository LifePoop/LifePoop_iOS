//
//  MockReportUseCase.swift
//  FeatureReportUseCase
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public final class MockReportUseCase: ReportUseCase {
    
    public init() { }
    
    public func fetchUserStoolReport(of period: ReportPeriod) -> Observable<StoolReport> {
        
        let mockWeekStoolReport = StoolReport(
            period: .week,
            totalStoolCount: 17,
            totalSatisfaction: 17,
            totalDissatisfaction: 0,
            totalStoolColor: [
                StoolColorReport(color: .brown, count: 4),
                StoolColorReport(color: .black, count: 6),
                StoolColorReport(color: .green, count: 7),
                StoolColorReport(color: .pink, count: 0),
                StoolColorReport(color: .yellow, count: 0)
            ],
            totalStoolShape: [
                StoolShapeReport(shape: .soft, count: 5),
                StoolShapeReport(shape: .good, count: 8),
                StoolShapeReport(shape: .hard, count: 4)
            ],
            totalStoolSize: [
                StoolSizeReport(shape: .soft, size: .small, count: 4),
                StoolSizeReport(shape: .soft, size: .medium, count: 2),
                StoolSizeReport(shape: .soft, size: .large, count: 2),
                StoolSizeReport(shape: .good, size: .small, count: 3),
                StoolSizeReport(shape: .good, size: .medium, count: 0),
                StoolSizeReport(shape: .good, size: .large, count: 2),
                StoolSizeReport(shape: .hard, size: .small, count: 2),
                StoolSizeReport(shape: .hard, size: .medium, count: 2),
                StoolSizeReport(shape: .hard, size: .large, count: 0)
            ]
        )
        
        let mockMonthStoolReport = StoolReport(
            period: .month,
            totalStoolCount: 80,
            totalSatisfaction: 55,
            totalDissatisfaction: 25,
            totalStoolColor: [
                StoolColorReport(color: .brown, count: 40),
                StoolColorReport(color: .black, count: 20),
                StoolColorReport(color: .green, count: 17),
                StoolColorReport(color: .pink, count: 0),
                StoolColorReport(color: .yellow, count: 3)
            ],
            totalStoolShape: [
                StoolShapeReport(shape: .soft, count: 32),
                StoolShapeReport(shape: .good, count: 28),
                StoolShapeReport(shape: .hard, count: 20)
            ],
            totalStoolSize: [
                StoolSizeReport(shape: .soft, size: .small, count: 16),
                StoolSizeReport(shape: .soft, size: .medium, count: 10),
                StoolSizeReport(shape: .soft, size: .large, count: 6),
                StoolSizeReport(shape: .good, size: .small, count: 14),
                StoolSizeReport(shape: .good, size: .medium, count: 9),
                StoolSizeReport(shape: .good, size: .large, count: 5),
                StoolSizeReport(shape: .hard, size: .small, count: 10),
                StoolSizeReport(shape: .hard, size: .medium, count: 8),
                StoolSizeReport(shape: .hard, size: .large, count: 2)
            ]
        )

        let mockThreeMonthsStoolReport = StoolReport(
            period: .threeMonths,
            totalStoolCount: 480,
            totalSatisfaction: 300,
            totalDissatisfaction: 180,
            totalStoolColor: [
                StoolColorReport(color: .brown, count: 240),
                StoolColorReport(color: .black, count: 144),
                StoolColorReport(color: .green, count: 90),
                StoolColorReport(color: .pink, count: 4),
                StoolColorReport(color: .yellow, count: 2)
            ],
            totalStoolShape: [
                StoolShapeReport(shape: .soft, count: 192),
                StoolShapeReport(shape: .good, count: 168),
                StoolShapeReport(shape: .hard, count: 120)
            ],
            totalStoolSize: [
                StoolSizeReport(shape: .soft, size: .small, count: 96),
                StoolSizeReport(shape: .soft, size: .medium, count: 60),
                StoolSizeReport(shape: .soft, size: .large, count: 36),
                StoolSizeReport(shape: .good, size: .small, count: 84),
                StoolSizeReport(shape: .good, size: .medium, count: 56),
                StoolSizeReport(shape: .good, size: .large, count: 28),
                StoolSizeReport(shape: .hard, size: .small, count: 60),
                StoolSizeReport(shape: .hard, size: .medium, count: 48),
                StoolSizeReport(shape: .hard, size: .large, count: 12)
            ]
        )

        let mockYearStoolReport = StoolReport(
            period: .year,
            totalStoolCount: 96000, // MARK: 임의의 매우 큰 수 입력
            totalSatisfaction: 60000,
            totalDissatisfaction: 36000,
            totalStoolColor: [
                StoolColorReport(color: .brown, count: 48000),
                StoolColorReport(color: .black, count: 28800),
                StoolColorReport(color: .green, count: 18000),
                StoolColorReport(color: .pink, count: 400),
                StoolColorReport(color: .yellow, count: 800)
            ],
            totalStoolShape: [
                StoolShapeReport(shape: .soft, count: 38400),
                StoolShapeReport(shape: .good, count: 33600),
                StoolShapeReport(shape: .hard, count: 24000)
            ],
            totalStoolSize: [
                StoolSizeReport(shape: .soft, size: .small, count: 19200),
                StoolSizeReport(shape: .soft, size: .medium, count: 12000),
                StoolSizeReport(shape: .soft, size: .large, count: 7200),
                StoolSizeReport(shape: .good, size: .small, count: 16800),
                StoolSizeReport(shape: .good, size: .medium, count: 11200),
                StoolSizeReport(shape: .good, size: .large, count: 5600),
                StoolSizeReport(shape: .hard, size: .small, count: 12000),
                StoolSizeReport(shape: .hard, size: .medium, count: 9600),
                StoolSizeReport(shape: .hard, size: .large, count: 2400)
            ]
        )
        
        switch period {
        case .week:
            return .just(mockWeekStoolReport)
        case .month:
            return .just(mockMonthStoolReport)
        case .threeMonths:
            return .just(mockThreeMonthsStoolReport)
        case .year:
            return .just(mockYearStoolReport)
        }
    }
}
