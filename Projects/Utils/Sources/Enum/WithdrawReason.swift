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
            return "기록하는 과정이 불편해서"
        case .noLongerNeeded:
            return "더 이상 사용의 필요성을 느끼지 못해서"
        case .inconvenientSharing:
            return "공유하는 과정이 불편해서"
        case .reportingNotUseful:
            return "리포트 기능이 유용하지 않아서"
        case .lackOfInterest:
            return "흥미가 떨어져서"
        }
    }
}
