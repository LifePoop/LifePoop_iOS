//
//  WithdrawReason.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum WithdrawReason: Int, CaseIterable {
    case inconvenientRecording
    case noLongerNeeded
    case inconvenientSharing
    case reportingNotUseful
    case lackOfInterest
    
    public var index: Int {
        return rawValue
    }
    
    public var title: String {
        switch self {
        case .inconvenientRecording:
            return LocalizableString.inconvenientRecording
        case .noLongerNeeded:
            return LocalizableString.noLongerNeeded
        case .inconvenientSharing:
            return LocalizableString.inconvenientSharing
        case .reportingNotUseful:
            return LocalizableString.reportingNotUseful
        case .lackOfInterest:
            return LocalizableString.lackOfInterest
        }
    }
}
