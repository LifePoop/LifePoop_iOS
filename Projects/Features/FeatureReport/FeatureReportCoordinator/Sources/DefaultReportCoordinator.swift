//
//  ReportCoordinator.swift
//  FeatureReportCoordinator
//
//  Created by 김상혁 on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import FeatureReportCoordinatorInterface
import FeatureReportPresentation
import Logger
import Utils

@available(*, deprecated, message: "리포트는 단일 화면이므로 코디네이터가 불필요함, 추후 리포트 화면의 전환 관리가 필요해질 경우 사용")
public final class DefaultReportCoordinator: ReportCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .report
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        coordinate(by: .flowDidStart)
    }
    
    public func coordinate(by coordinateAction: ReportCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .flowDidStart:
                break
            }
        }
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
