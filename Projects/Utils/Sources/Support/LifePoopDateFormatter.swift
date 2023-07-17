//
//  LifePoopDateFormatter.swift
//  Utils
//
//  Created by 김상혁 on 2023/07/17.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

final class LifePoopDateFormatter {
    static let shared = LifePoopDateFormatter()
    
    private let userLocale: Locale = {
        if let regionCode = Locale.current.regionCode,
           let languageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first {
            let localeIdentifier = "\(languageCode)_\(regionCode)"
            return Locale(identifier: localeIdentifier)
        } else {
            return Locale.current
        }
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = userLocale
        return formatter
    }()
    
    private init() { }
    
    func localizedString(from date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: date)
    }
}
