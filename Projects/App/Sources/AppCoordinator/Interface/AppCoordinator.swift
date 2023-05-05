//
//  AppCoordinator.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import Utils

public protocol AppCoordinator: Coordinator {
    func coordinate(by coordinateAction: AppCoordinateAction)
}
