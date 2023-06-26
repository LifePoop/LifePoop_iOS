//
//  ReportPeriod.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

// MARK: - 서버 DTO 구성되기 전 임의로 사용하는 Entity
public enum ReportPeriod: Int, CaseIterable {
    case week
    case month
    case threeMonths
    case year
    
    public var title: String {
        switch self {
        case .week:
            return LocalizableString.recent
        case .month:
            return LocalizableString.oneMonth
        case .threeMonths:
            return LocalizableString.threeMonths
        case .year:
            return LocalizableString.oneYear
        }
    }
    
    public var description: String {
        switch self {
        case .week:
            return LocalizableString.sevenDays
        case .month:
            return LocalizableString.oneMonth
        case .threeMonths:
            return LocalizableString.threeMonths
        case .year:
            return LocalizableString.oneYear
        }
    }
    
    public static var titles: [String] {
        return allCases.map { $0.title }
    }
}
