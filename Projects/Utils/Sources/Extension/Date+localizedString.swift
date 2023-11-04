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
    var dateString: String {
        return LifePoopDateFormatter.shared.convertDateToString(from: self, with: .koreanTimeZone)
    }
    
    /// 한국어로 현지화된 'yyyy년 MM월 dd일' 형태의 `String` 타입으로 변환합니다. (시간은 포함되지 않습니다.)
    ///
    /// 예) "2023년 6월 21일"
    var koreanDateString: String {
        return LifePoopDateFormatter.shared.convertDateToKoreanLocalizedString(from: self)
    }
    
    /// 현지화된 long 스타일의 `String` 타입으로 변환합니다. (시간은 포함되지 않습니다.)
    ///
    /// 예) 한국어: "2023년 6월 21일", 영어: "October 23, 2023"
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
    
    /// 현재 시간 기준 시간 차이를 N시간  N분 전 형태의 `String` 타입으로 변환합니다.
    ///
    /// 시간 차이가 1시간 이내일 경우 N분 전, 1시간 이상일 경우 N시간 전으로 자동 변환합니다.
    ///
    /// 예) "1시간 전", "1분 전"
    var localizedTimeDifferenceSinceCurrentDateString: String {
        let currentDate = Date()
        let timeDifference = currentDate.timeIntervalSince(self)
        
        return timeDifference >= 60 * 60
        ? "\(Int(timeDifference / (60 * 60)))\(LocalizableString.hours) 전"
        : "\(Int(timeDifference / 60))\(LocalizableString.minutes) 전"
    }
}
