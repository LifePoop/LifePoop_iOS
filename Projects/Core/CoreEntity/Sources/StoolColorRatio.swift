//
//  StoolColorRatio.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoolColorRatio: Hashable {
    public let color: StoolColor
    public let ratio: Double
    
    public init(color: StoolColor, ratio: Double) {
        self.color = color
        self.ratio = ratio
    }
}
