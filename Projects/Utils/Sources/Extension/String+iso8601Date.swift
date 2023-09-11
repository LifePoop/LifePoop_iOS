//
//  String+iso8601Date.swift
//  Utils
//
//  Created by 김상혁 on 2023/09/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension String {
    var iso8601Date: Date? {
        return LifePoopDateFormatter.shared.convertISO8601FormatStringToDate(from: self)
    }
}
