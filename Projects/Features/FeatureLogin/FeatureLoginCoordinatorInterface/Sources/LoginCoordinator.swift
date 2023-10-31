//
//  LoginCoordinator.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public protocol LoginCoordinator: Coordinator {
    func start(showLaunchScreen: Bool)
    func coordinate(by coordinateAction: LoginCoordinateAction)
    var flowCompletionDelegate: LoginCoordinatorCompletionDelegate? { get }
}

extension LoginCoordinator {
    
    public func start() {
        start(showLaunchScreen: true)
    }
}
