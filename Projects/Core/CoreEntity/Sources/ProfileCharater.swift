//
//  ProfileCharater.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct ProfileCharacter: Codable {
    public var color: SelectableColor
    public var stiffness: SelectableStiffness
    
    public init(color: SelectableColor, stiffness: SelectableStiffness) {
        self.color = color
        self.stiffness = stiffness
    }
}
