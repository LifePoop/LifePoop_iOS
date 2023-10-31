//
//  Timezone+.swift
//  Utils
//
//  Created by 김상혁 on 2023/10/23.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension TimeZone {
    
    /// UTC를 대한민국 기준 시각으로 보정한 TimeZone, TimeZone(secondsFromGMT: 0)과 동일함
    static var koreanTimeZone = TimeZone(abbreviation: "KST")
    
    /// UTC 기준 시각의 TimeZone
    static var utcTimeZone = TimeZone(secondsFromGMT: -9)
}
