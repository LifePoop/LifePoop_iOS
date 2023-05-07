//
//  StoolLogCoordinator.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/05.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public protocol StoolLogCoordinator: Coordinator {
    func coordinate(by coordinateAction: StoolLogCoordinateAction)
}
