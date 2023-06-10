//
//  ProfileCharater.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct ProfileCharacter: Codable, Equatable {
    public var color: StoolColor
    public var shape: StoolShape
    
    public init(color: StoolColor, shape: StoolShape) {
        self.color = color
        self.shape = shape
    }
}
