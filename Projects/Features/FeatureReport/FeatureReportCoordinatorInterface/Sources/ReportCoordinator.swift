//
//  ReportCoordinator.swift
//  FeatureReportCoordinatorInterface
//
//  Created by 김상혁 on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public protocol ReportCoordinator: Coordinator {
    func coordinate(by coordinateAction: ReportCoordinateAction)
}
