//
//  StoolColorReport.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoolColorReport {
    public let color: StoolColor
    public let count: Int
    public let barWidthRatio: Double
    
    public init(color: StoolColor, count: Int, barWidthRatio: Double) {
        self.color = color
        self.count = count
        self.barWidthRatio = barWidthRatio
    }
}
