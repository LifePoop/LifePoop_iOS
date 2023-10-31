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
        return formatter
    }()
    
    func convertDateToString(from date: Date, with timeZone: TimeZone?) -> String {
        dateFormatter.timeZone = timeZone
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
    
    func convertDateToKoreanLocalizedString(from date: Date) -> String {
        dateFormatter.timeZone = .koreanTimeZone
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
    
    /// 2023-10-23 13:28:10 +0000 형태의 Date를 API 형식에 맞추기 위해 UTC 기준의 iSO8601 형태의 String으로 변환
    func convertDateToISO8601FormatString(from date: Date) -> String {
        iso8601DateFormatter.timeZone = .utcTimeZone
        let dateString = iso8601DateFormatter
            .string(from: date)
            .replacingOccurrences(of: "+09:00", with: "Z")
        return dateString
    }
    
    /// 서버에서 받은 UTC 기준의 iSO8601 형태의 String을 Date 타입으로 변환
    func convertISO8601FormatStringToDate(from dateString: String) -> Date? {
        iso8601DateFormatter.timeZone = .utcTimeZone
        let date = iso8601DateFormatter.date(from: dateString)
        return date
    }
}
