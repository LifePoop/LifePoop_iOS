//
//  LoginCoordinateAction.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import CoreEntity

public enum LoginCoordinateAction {
    case shouldShowLaunchScreen
    case shouldShowLoginScene
    case shouldPopCurrentScene
    case didTapAppleLoginButton(userAuthInfo: UserAuthInfoEntity)
    case didTapKakaoLoginButton(userAuthInfo: UserAuthInfoEntity)
    case shouldFinishLoginFlow
}
