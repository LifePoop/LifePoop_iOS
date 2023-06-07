//
//  RawRepresentable+index.swift
//  Utils
//
//  Created by 김상혁 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension RawRepresentable where Self: CaseIterable, RawValue == Int {
    var index: Int {
        return rawValue
    }
}
