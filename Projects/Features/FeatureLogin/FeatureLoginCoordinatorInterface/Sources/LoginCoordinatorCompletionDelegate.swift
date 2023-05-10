//
//  LoginCoordinatorCompletionDelegate.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol LoginCoordinatorCompletionDelegate: AnyObject {
    func showNextFlow()
}
