//
//  StoolShape.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/07.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public enum StoolShape: Int, Codable, CaseIterable {
    case soft
    case good
    case hard
}

extension StoolShape: CustomStringConvertible {

    public var description: String {
        switch self {
        case .soft:
            return LocalizableString.soft
        case .good:
            return LocalizableString.good
        case .hard:
            return LocalizableString.hard
        }
    }
}
