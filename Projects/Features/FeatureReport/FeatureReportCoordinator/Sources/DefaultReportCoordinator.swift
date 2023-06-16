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
import Utils

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
        switch coordinateAction {
        case .flowDidStart:
            pushReportViewController()
        }
    }
}

// MARK: - Coordinating Methods

private extension DefaultReportCoordinator {
    func pushReportViewController() {
        let viewController = ReportViewController()
        let viewModel = ReportViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
