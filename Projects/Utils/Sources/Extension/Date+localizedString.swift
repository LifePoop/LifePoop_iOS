//
//  Date+localizedString.swift
//  Utils
//
//  Created by 김상혁 on 2023/06/21.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension Date {
    var localizedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        if let regionCode = Locale.current.regionCode,
           let languageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first {
            let localeIdentifier = "\(languageCode)_\(regionCode)"
            formatter.locale = Locale(identifier: localeIdentifier)
        } else {
            formatter.locale = Locale.current
        }
        
        return formatter.string(from: self)
    }
}
