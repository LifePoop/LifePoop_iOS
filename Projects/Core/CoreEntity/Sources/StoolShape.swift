//
//  StoolShape.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum StoolShape: Int, Codable, CaseIterable {
    case soft
    case good
    case hard
    
    public var description: String {
        switch self {
        case .soft:
            return "무름"
        case .good:
            return "적당"
        case .hard:
            return "딱딱"
        }
    }
}
