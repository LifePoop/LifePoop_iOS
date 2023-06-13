//
//  ReportPeriod.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

// MARK: - 서버 DTO 구성되기 전 임의로 사용하는 Entity
public enum ReportPeriod: Int, CaseIterable {
    case week
    case month
    case threeMonths
    case year
    
    public var text: String {
        switch self {
        case .week:
            return "7일"
        case .month:
            return "1개월"
        case .threeMonths:
            return "3개월"
        case .year:
            return "1년"
        }
    }
    
    public static var texts: [String] {
        return allCases.map { $0.text }
    }
}
