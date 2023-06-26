//
//  LifePoopAlertViewType.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/05/22.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum LifePoopAlertViewType {
    case logout
    case withdraw
    case invitationCode
    
    public var title: String {
        switch self {
        case .logout:
            return DesignSystemStrings.logOutWarningTitle
        case .withdraw:
            return DesignSystemStrings.withdrawWarningTitle
        case .invitationCode:
            return DesignSystemStrings.enterInvitationCode
        }
    }
    
    public var subTitle: String {
        switch self {
        case .logout:
            return DesignSystemStrings.logOutWarningDescription
        case .withdraw:
            return DesignSystemStrings.withdrawWarningDescription
        case .invitationCode:
            return DesignSystemStrings.enterInvitationCodeYouReceivedFromYourFriend
        }
    }
    
    public var cancelButtonTitle: String {
        return DesignSystemStrings.cancel
    }
    
    public var confirmButtonTitle: String {
        switch self {
        case .logout:
            return DesignSystemStrings.confirmSignOut
        case .withdraw:
            return DesignSystemStrings.withdraw
        case .invitationCode:
            return DesignSystemStrings.doneEntering
        }
    }
}
