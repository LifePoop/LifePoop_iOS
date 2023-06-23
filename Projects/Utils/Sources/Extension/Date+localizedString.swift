//
//  Date+localizedString.swift
//  Utils
//
//  Created by 김상혁 on 2023/06/21.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public extension Date {
    private var userLocale: Locale {
        if let regionCode = Locale.current.regionCode,
           let languageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first {
            let localeIdentifier = "\(languageCode)_\(regionCode)"
            return Locale(identifier: localeIdentifier)
        } else {
            return Locale.current
        }
    }
    
    var localizedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = userLocale
        return formatter.string(from: self)
    }
    
    var localizedTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = userLocale
        return formatter.string(from: self)
    }
}
