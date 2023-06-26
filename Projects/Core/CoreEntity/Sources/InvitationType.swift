//
//  InvitationType.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public enum InvitationType: CustomStringConvertible, CaseIterable {
    
    case sharingInvitationCode
    case enteringInvitationCode
    
    public var description: String {
        switch self {
        case .sharingInvitationCode:
            return LocalizableString.shareInvitationCode
        case .enteringInvitationCode:
            return LocalizableString.enterInvitationCode
        }
    }
}
