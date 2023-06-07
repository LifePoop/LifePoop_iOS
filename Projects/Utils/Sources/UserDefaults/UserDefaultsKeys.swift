//
//  UserDefaultsKeys.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum UserDefaultsKeys: String {
    case userLoginType = "UserLoginType"
    case userNickname = "UserNickname"
    case feedVisibility = "FeedVisibility"
    case isAutoLoginActivated = "IsAutoLoginActivated"
    case profileCharacter = "ProfileCharacter"
    
    case isAppFirstlyLaunched = "IsAppFirstlyLaunched"
    
    public var rawKey: String {
        return rawValue
    }
}
