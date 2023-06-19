//
//  ColoredStoolShape.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct ColoredStoolShape {
    
    public let shape: StoolShape
    public let color: StoolColor?
    public let isSelected: Bool
    
    public init(shape: StoolShape, color: StoolColor?, isSelected: Bool = false) {
        self.shape = shape
        self.color = color
        self.isSelected = isSelected
    }
}
