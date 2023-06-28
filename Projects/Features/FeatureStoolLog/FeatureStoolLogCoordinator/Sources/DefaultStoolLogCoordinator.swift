//
//  DefaultStoolLogCoordinator.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/05.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay

import CoreEntity
import DesignSystem
import FeatureStoolLogCoordinatorInterface
import FeatureStoolLogPresentation
import Logger
import Utils

public final class DefaultStoolLogCoordinator: StoolLogCoordinator {
    
    public var parentCoordinator: Coordinator?
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public var type: Utils.CoordinatorType = .stoolLog
    
    struct SharedState {
        let stoolLogsRelay: BehaviorRelay<[StoolLogEntity]>
    }
    
    private let sharedState: SharedState
    
    public init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator?,
        stoolLogsRelay: BehaviorRelay<[StoolLogEntity]>
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.sharedState = SharedState(stoolLogsRelay: stoolLogsRelay)
    }
        
    public func start() {
        coordinate(by: .bottomSheetDidShow)
    }
    
    public func coordinate(by coordinateAction: StoolLogCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch coordinateAction {
            case .bottomSheetDidShow:
                self.pushViewController(
                    SatisfactionSelectViewController(),
                    with: SatisfactionSelectViewModel(coordinaotr: self)
                )
            case .didSelectSatisfaction(let isSatisfied):
                self.pushViewController(
                    SatisfactionDetailViewController(),
                    with: SatisfactionDetailViewModel(
                        coordinator: self,
                        isSatisfied: isSatisfied,
                        stoolLogs: self.sharedState.stoolLogsRelay
                    )
                )
            case .goBack:
                self.popViewController()
            case .dismissBottomSheet:
                self.dismissBottomSheet()
            }
        }
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

private extension DefaultStoolLogCoordinator {

    func pushViewController<VC: ViewType, VM: ViewModelType>(_ viewController: VC, with viewModel: VM) {
        guard let viewModel = viewModel as? VC.ViewModel else { return }
        viewController.bind(viewModel: viewModel)
        
        if let viewController = viewController as? UIViewController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissBottomSheet() {
        guard let parentViewController = parentCoordinator?.navigationController.presentedViewController else { return }
        
        parentViewController.children.forEach {
            if let bottomSheetController = $0 as? BottomSheetController {
                bottomSheetController.closeBottomSheet()
            }
        }
    }
}

extension DefaultStoolLogCoordinator: BottomSheetDelegate {
    
    public func bottomSheetDidDisappear() {
        parentCoordinator?.remove(childCoordinator: .stoolLog)
    }
}
