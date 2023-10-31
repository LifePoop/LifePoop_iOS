//
//  StoolColor.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public enum StoolColor: Int, Codable, CaseIterable {
    case brown
    case black
    case pink
    case green
    case yellow
}

extension StoolColor: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .brown:
            return LocalizableString.brown
        case .black:
            return LocalizableString.black
        case .pink:
            return LocalizableString.pink
        case .green:
            return LocalizableString.green
        case .yellow:
            return LocalizableString.yellow
        }
    }
}
