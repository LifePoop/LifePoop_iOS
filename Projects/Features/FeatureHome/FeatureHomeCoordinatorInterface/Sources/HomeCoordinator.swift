//
//  HomeCoordinator.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import Utils

public protocol HomeCoordinator: Coordinator {
    func coordinate(by coordinateAction: HomeCoordinateAction)
    func start(animated: Bool)
}

extension HomeCoordinator {
    
    public func start() { }
}
