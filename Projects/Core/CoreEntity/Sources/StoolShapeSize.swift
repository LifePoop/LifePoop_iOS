//
//  StoolShapeSize.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/10/31.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoolShapeSize: Hashable {
    public let shape: StoolShape
    public let size: StoolSize
    
    public init(shape: StoolShape, size: StoolSize) {
        self.shape = shape
        self.size = size
    }
}
