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
    
    private init() { }
    
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
    
    private lazy var iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    func convertDateToString(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func convertDateToLocalizedString(
        from date: Date,
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style
    ) -> String {
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: date)
    }
    
    func convertDateToISO8601FormatString(from date: Date) -> String {
        let dateString = iso8601DateFormatter
            .string(from: date)
            .replacingOccurrences(of: "+09:00", with: "Z")
        return dateString
    }
    
    func convertISO8601FormatStringToDate(from dateString: String) -> Date? {
        return iso8601DateFormatter.date(from: dateString)
    }
}
