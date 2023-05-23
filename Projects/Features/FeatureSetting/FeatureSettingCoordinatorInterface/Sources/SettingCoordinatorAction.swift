//
//  SettingCoordinatorAction.swift
//  FeatureSettingCoordinatorInterface
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum SettingCoordinateAction {
    case flowDidStart
    case flowDidFinish
    case profileInfoDidTap
    case termsOfServiceDidTap(title: String, text: String?)
    case privacyPolicyDidTap(title: String, text: String?)
    case sendFeedbackDidTap
    case withdrawButtonDidTap
    case logOutConfirmButtonDidTap
    case withdrawConfirmButtonDidTap
}
