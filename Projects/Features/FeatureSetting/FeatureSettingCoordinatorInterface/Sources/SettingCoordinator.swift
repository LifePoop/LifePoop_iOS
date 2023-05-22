//
//  SettingCoordinator.swift
//  FeatureSettingCoordinator
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public protocol SettingCoordinator: Coordinator {
    var completionDelegate: SettingCoordinatorCompletionDelegate? { get set }
    func coordinate(by coordinateAction: SettingCoordinateAction)
}
