//
//  SelectableStiffness.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum SelectableStiffness: Codable, CaseIterable { // FIXME: 네이밍 수정
    
    case soft
    case normal
    case stiffness
    
    public var description: String {
        switch self {
        case .soft:
            return "무름"
        case .normal:
            return "적당"
        case .stiffness:
            return "딱딱"
        }
    }
}
