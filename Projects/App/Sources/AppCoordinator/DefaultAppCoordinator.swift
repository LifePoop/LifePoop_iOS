//
//  DefaultAppCoordinator.swift
//  App
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import CoreDataMapper
import CoreDIContainer
import CoreNetworkService
import CoreStorageService
import FeatureLoginDIContainer
import FeatureLoginPresentation
import FeatureLoginRepository
import FeatureLoginUseCase
import Utils

public final class DefaultAppCoordinator: AppCoordinator {
    
    public var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    public var navigationController: UINavigationController
    public let type: CoordinatorType = .app
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        registerDependencies()
    }
    
    public func start() {
        coordinate(by: .appDidStart)
    }
    
    public func coordinate(by action: AppCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch action {
            case .appDidStart:
                self?.startLoginCoordinatorFlow()
            case .accessTokenDidfetch:
                self?.startHomeCoordinatorFlow()
            }
        }
    }
}

// MARK: - Dependency Registration

private extension DefaultAppCoordinator {
    func registerDependencies() {
        LoginDIContainer.shared.register(service: LoginUseCase.self) { DefaultLoginUseCase() }
        LoginDIContainer.shared.register(service: LoginRepository.self) { DefaultLoginRepository() }
        
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(CoreExampleDataMapper()) }
        CoreDIContainer.shared.register(service: EndpointService.self) { URLSessionEndpointService.shared }
        CoreDIContainer.shared.register(service: URLDataService.self) { URLSessionURLDataService.shared }
        CoreDIContainer.shared.register(service: DiskCacheStorage.self) { FileManagerDiskCacheStorage.shared }
        CoreDIContainer.shared.register(service: MemoryCacheStorage.self) { NSCacheMemoryCacheStorage.shared }
    }
}

// MARK: - Coordinating Methods

private extension DefaultAppCoordinator {
    func startLoginCoordinatorFlow() {
        let loginCoordinator = DefaultLoginCoordinator(
            navigationController: navigationController,
            flowCompletionDelegate: self
        )
        add(childCoordinator: loginCoordinator)
        loginCoordinator.start()
    }
    
    func startHomeCoordinatorFlow() {
        // TODO: Home Feature
/*
        import FeatureHomeDIContainer
        import FeatureHomePresentation
        import FeatureHomeRepository
        import FeatureHomeUseCase
         
        let homeCoordinator = DefaultHomeCoordinator(navigationController: navigationController)
        add(childCoordinator: homeCoordinator)
        homeCoordinator.start()
 */
        let homeVC = UIViewController()
        homeVC.view.backgroundColor = .blue
        navigationController.setViewControllers([homeVC], animated: true)
    }
}

// MARK: - CompletionDelegate

extension DefaultAppCoordinator: LoginCoordinatorCompletionDelegate {
    public func showNextFlow() {
        remove(childCoordinator: .login)
        coordinate(by: .accessTokenDidfetch)
    }
}
