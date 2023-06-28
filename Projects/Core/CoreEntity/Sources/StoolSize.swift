//
//  StoolSize.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public enum StoolSize: Int, CaseIterable, CustomStringConvertible {
    case small
    case medium
    case large
    
    public var description: String {
        switch self {
        case .small:
            return LocalizableString.small
        case .medium:
            return LocalizableString.medium
        case .large:
            return LocalizableString.large
        }
    }
    
    public static var allCases: [StoolSize] {
        return [.large, .medium, .small]
    }
}
