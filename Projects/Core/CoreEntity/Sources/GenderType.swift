//
//  GenderType.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/09.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum GenderType: CaseIterable, CustomStringConvertible {
    
    case male
    case female
    case etc
    
    public var description: String {
        switch self {
        case .male: return "남성"
        case .female: return "여성"
        case .etc: return "기타"
        }
    }
}
