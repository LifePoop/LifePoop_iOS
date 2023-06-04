//
//  SettingCoordinatorCompletionDelegate.swift
//  FeatureSettingCoordinatorInterface
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol SettingCoordinatorCompletionDelegate: AnyObject {
    func finishFlow()
    func finishFlow(by completion: SettingFlowCompletion)
}
