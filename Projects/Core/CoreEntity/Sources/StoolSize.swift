//
//  StoolSize.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum StoolSize: Int, CaseIterable, CustomStringConvertible {
    case small
    case medium
    case large
    
    public var description: String {
        switch self {
        case .small:
            return "소"
        case .medium:
            return "중"
        case .large:
            return "대"
        }
    }
    
    public static var allCases: [StoolSize] {
        return [.large, .medium, .small]
    }
}
