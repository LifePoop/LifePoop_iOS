//
//  DefaultHomeCoordinator.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import DesignSystem

import UIKit

import Utils

import FeatureStoolLogPresentation

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
    
    typealias TransparentBackgroundViewController = UIViewController
    func presentTransparentBackgroundView() {
        let backgroundViewController = TransparentBackgroundViewController()
        backgroundViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(backgroundViewController, animated: false)
    }
    
    func presentBottomSheetController(contentViewController: UIViewController)
    -> BottomSheetController? {
        guard let bottomSheetController = createBottomSheetController(),
              let parentViewController = navigationController.presentedViewController else {
            
            navigationController.presentedViewController?.dismiss(animated: false)
            return nil
        }
        
        bottomSheetController.setBottomSheet(contentViewController: contentViewController)
        bottomSheetController.showBottomSheet(toParent: parentViewController)

        return bottomSheetController
    }

    func createBottomSheetController() -> BottomSheetController? {
        presentTransparentBackgroundView()
        guard let parentViewController = navigationController.presentedViewController else { return nil }

        let bottomSheetController = BottomSheetController(
            bottomSheetHeight: parentViewController.view.bounds.height*0.5
        )
        return bottomSheetController
    }
}

// MARK: - Coordinating Methods

private extension DefaultHomeCoordinator {

    func startStoolLogCoordinatorFlow() {
        let stoolLogCoordinator = DefaultStoolLogCoordinator(
            navigationController: UINavigationController(),
            parentCoordinator: self
        )
        add(childCoordinator: stoolLogCoordinator)

        guard let bottomSheetController = presentBottomSheetController(
            contentViewController: stoolLogCoordinator.navigationController
        ) else { return }
        
        bottomSheetController.delegate = stoolLogCoordinator
        stoolLogCoordinator.start()
    }
}
