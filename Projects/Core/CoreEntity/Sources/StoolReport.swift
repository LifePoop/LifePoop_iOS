//
//  StoolReport.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoolReport {
    public let period: ReportPeriod
    public let totalStoolCount: Int
    public let totalSatisfaction: Int
    public let totalStoolColorCountMap: [StoolColor: Int]
    public let totalStoolShapeCountMap: [StoolShape: Int]
    public let totalStoolShapeSizeCountMap: [StoolShapeSize: Int]
    
    public var totalDissatisfaction: Int {
        return totalStoolCount - totalSatisfaction
    }
    
    public init(
        period: ReportPeriod,
        totalStoolCount: Int,
        totalSatisfaction: Int,
        totalStoolColorCountMap: [StoolColor: Int],
        totalStoolShapeCountMap: [StoolShape: Int],
        totalStoolSizeCountMap: [StoolShapeSize: Int]
    ) {
        self.period = period
        self.totalStoolCount = totalStoolCount
        self.totalSatisfaction = totalSatisfaction
        self.totalStoolColorCountMap = totalStoolColorCountMap
        self.totalStoolShapeCountMap = totalStoolShapeCountMap
        self.totalStoolShapeSizeCountMap = totalStoolSizeCountMap
    }
}
