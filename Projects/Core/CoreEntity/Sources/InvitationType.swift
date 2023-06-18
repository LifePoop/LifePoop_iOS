//
//  InvitationType.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum InvitationType: CustomStringConvertible, CaseIterable {
    
    case sharingInvitationCode
    case enteringInvitationCode
    
    public var description: String {
        switch self {
        case .sharingInvitationCode:
            return "초대 코드 공유하기"
        case .enteringInvitationCode:
            return "초대 코드 입력하기"
        }
    }
}
