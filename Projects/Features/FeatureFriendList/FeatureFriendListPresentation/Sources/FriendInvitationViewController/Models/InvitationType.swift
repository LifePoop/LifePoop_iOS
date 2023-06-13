//
//  InvitationType.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

enum InvitationType: CustomStringConvertible, CaseIterable {
    
    case sharingInvitationCode
    case enteringInvitationCode
    
    var description: String {
        switch self {
        case .sharingInvitationCode:
            return "초대 코드 공유하기"
        case .enteringInvitationCode:
            return "친구 추가 코드 입력하기"
        }
    }
}
