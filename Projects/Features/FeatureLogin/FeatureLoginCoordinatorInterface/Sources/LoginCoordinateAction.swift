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
    case startLoginFlow(showLaunchScreen: Bool)
    case skipLoginFlow
    case showLoginScene
    case showDetailForm(title: String, detailText: String)
    case popCurrentScene
    case didTapAppleLoginButton(userAuthInfo: OAuthTokenInfo)
    case didTapKakaoLoginButton(userAuthInfo: OAuthTokenInfo)
    case finishLoginFlow
}
