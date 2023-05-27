//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/22.
//

import UIKit

import CoreDIContainer
import CoreNetworkService
import CoreStorageService

import FeatureHomeDIContainer
import FeatureHomeRepository
import FeatureHomeUseCase
import FeatureLoginDIContainer
import FeatureLoginRepository
import FeatureLoginUseCase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        configureNavigationBarBackButtonItem()
        registerAllDependencies()
        
        let rootNavigationController = UINavigationController()
        appCoordinator = DefaultAppCoordinator(navigationController: rootNavigationController)
        appCoordinator?.start()
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Dependency Registration

private extension SceneDelegate {
    func registerAllDependencies() {
        registerCoreDependencies()
        registerLoginDependencies()
        registerHomeDependencies()
    }
    
    func registerCoreDependencies() {
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(CoreExampleDataMapper()) }
        CoreDIContainer.shared.register(service: EndpointService.self) { URLSessionEndpointService.shared }
        CoreDIContainer.shared.register(service: URLDataService.self) { URLSessionURLDataService.shared }
        CoreDIContainer.shared.register(service: DiskCacheStorage.self) { FileManagerDiskCacheStorage.shared }
        CoreDIContainer.shared.register(service: MemoryCacheStorage.self) { NSCacheMemoryCacheStorage.shared }
    }
    
    func registerLoginDependencies() {
        LoginDIContainer.shared.register(service: LoginUseCase.self) { DefaultLoginUseCase() }
        LoginDIContainer.shared.register(service: LoginRepository.self) { DefaultLoginRepository() }
    }
    
    func registerHomeDependencies() {
        HomeDIContainer.shared.register(service: HomeUseCase.self) { DefaultHomeUseCase() }
        HomeDIContainer.shared.register(service: HomeRepository.self) { DefaultHomeRepository() }
    }
}

// MARK: - UI Setup

private extension SceneDelegate {
    func configureNavigationBarBackButtonItem() {
        let emptyImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        UINavigationBar.appearance().backIndicatorImage = emptyImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = emptyImage
    }
}
