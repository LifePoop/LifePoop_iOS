//
//  Date+localizedString.swift
//  Utils
//
//  Created by 김상혁 on 2023/06/21.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension Date {
    /// 'yyyy-MM-dd' 형태의 `String` 타입으로 변환합니다. (시간은 포함되지 않습니다.)
    ///
    /// 예) "2023-06-21"
    var dateString: String { // TODO: Rename
        return LifePoopDateFormatter.shared.convertDateToString(from: self)
    }
    
    /// 현지화된 long 스타일의 `String` 타입으로 변환합니다. (시간은 포함되지 않습니다.)
    ///
    /// 예) "2023년 6월 21일"
    var localizedDateString: String {
        return LifePoopDateFormatter.shared.convertDateToLocalizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
    
    /// 현지화된 short 스타일의 `String` 타입으로 변환합니다. (날짜는 포함되지 않습니다.)
    ///
    /// 예) "오후 2:30"
    var localizedTimeString: String {
        return LifePoopDateFormatter.shared.convertDateToLocalizedString(from: self, dateStyle: .none, timeStyle: .short)
    }
    
    /// ISO8601 형식의 `String` 타입으로 변환합니다.
    ///
    /// 예)  "2023-09-10T15:30:00Z"
    var iso8601FormatDateString: String {
        return LifePoopDateFormatter.shared.convertDateToISO8601FormatString(from: self)
    }
}
