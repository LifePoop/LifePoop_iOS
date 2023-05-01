//
//  DefaultHomeCoordinator.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import Utils

public final class DefaultHomeCoordinator: HomeCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .home
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        coordinate(by: .flowDidStart)
    }
    
    public func coordinate(by coordinateAction: HomeCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch coordinateAction {
            case .flowDidStart:
                self?.pushHomeViewController()
            case .stoolLogButtonDidTap:
                self?.startStoolLogCoordinatorFlow()
            }
        }
    }
}

// MARK: - Coordinating Methods

private extension DefaultHomeCoordinator {
    func pushHomeViewController() {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(coordinator: self)
        viewController.bind(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

// MARK: - Coordinating Methods

private extension DefaultHomeCoordinator {
    func startStoolLogCoordinatorFlow() {
        // TODO: StoolLogCoordinator Flow 구현
        print(#function)
    }
}
