//
//  SettingCoordinatorAction.swift
//  FeatureSettingCoordinatorInterface
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay

import CoreEntity

public enum SettingCoordinateAction {
    case flowDidStart
    case flowDidFinish
    case profileInfoDidTap(userNickname: BehaviorRelay<String>)
    case profileCharacterEditDidTap(profileCharacter: BehaviorRelay<ProfileCharacter?>)
    case feedVisibilityDidTap(feedVisibility: BehaviorRelay<FeedVisibility?>)
    case termsOfServiceDidTap(title: String, text: String?)
    case privacyPolicyDidTap(title: String, text: String?)
    case sendFeedbackDidTap
    case withdrawButtonDidTap
    case logOutConfirmButtonDidTap
    case withdrawConfirmButtonDidTap
}
