//
//  StoolReport.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

// MARK: - 서버 DTO 구성되기 전 임의로 사용하는 Entity
public struct StoolReport {
    public let period: ReportPeriod
    public let totalStoolCount: Int
    public let totalSatisfaction: Int
    public let totalDissatisfaction: Int
    public let totalStoolColor: [StoolColorReport]
    public let totalStoolShape: [StoolShapeReport]
    public let totalStoolSize: [StoolSizeReport]
    
    public init(
        period: ReportPeriod,
        totalStoolCount: Int,
        totalSatisfaction: Int,
        totalDissatisfaction: Int,
        totalStoolColor: [StoolColorReport],
        totalStoolShape: [StoolShapeReport],
        totalStoolSize: [StoolSizeReport]
    ) {
        self.period = period
        self.totalStoolCount = totalStoolCount
        self.totalSatisfaction = totalSatisfaction
        self.totalDissatisfaction = totalDissatisfaction
        self.totalStoolColor = totalStoolColor
        self.totalStoolShape = totalStoolShape
        self.totalStoolSize = totalStoolSize
    }
}

public struct StoolShapeReport {
    public let shape: StoolShape
    public let count: Int
    
    public init(shape: StoolShape, count: Int) {
        self.shape = shape
        self.count = count
    }
}

public struct StoolColorReport {
    public let color: StoolColor
    public let count: Int
    
    public init(color: StoolColor, count: Int) {
        self.color = color
        self.count = count
    }
}

public struct StoolSizeReport {
    public let shape: StoolShape
    public let size: StoolSize
    public let count: Int
    
    public init(shape: StoolShape, size: StoolSize, count: Int) {
        self.shape = shape
        self.size = size
        self.count = count
    }
}
