//
//  String+iso8601Date.swift
//  Utils
//
//  Created by 김상혁 on 2023/09/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension String {
    /// ISO8601 형식의 `String` 타입을 `Date?` 타입으로 변환합니다.
    /// ISO8601 형식이 아닐 경우, `nil`을 반환합니다.
    ///
    /// 예) "2023-09-10T15:30:00Z"
    var iso8601Date: Date? {
        return LifePoopDateFormatter.shared.convertISO8601FormatStringToDate(from: self)
    }
}
