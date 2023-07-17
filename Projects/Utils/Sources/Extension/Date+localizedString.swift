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
        return LifePoopDateFormatter.shared.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
    
    var localizedTimeString: String {
        return LifePoopDateFormatter.shared.localizedString(from: self, dateStyle: .none, timeStyle: .short)
    }
}
