//
//  Date+localizedString.swift
//  Utils
//
//  Created by 김상혁 on 2023/06/21.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension Date {
    var localizedDateString: String {
        return LifePoopDateFormatter.shared.convertDateToLocalizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
    
    var localizedTimeString: String {
        return LifePoopDateFormatter.shared.convertDateToLocalizedString(from: self, dateStyle: .none, timeStyle: .short)
    }
    
    var iso8601FormatDateString: String {
        return LifePoopDateFormatter.shared.convertDateToISO8601FormatString(from: self)
    }
}
