//
//  CaseIterable+index.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension CaseIterable {
    static subscript(index: Int) -> Self? {
        guard index >= .zero, index < Self.allCases.count else {
            return nil
        }
        
        let casesArray = Array(Self.allCases)
        return casesArray[index]
    }
}

public extension CaseIterable where Self: Equatable {
    static func indexOf(case: Self) -> Int? {
        let casesArray = Array(Self.allCases)
        return casesArray.firstIndex(where: { $0 == `case` })
    }
}
