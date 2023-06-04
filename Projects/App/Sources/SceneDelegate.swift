//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/22.
//

import UIKit

import CoreAuthentication
import CoreDIContainer
import CoreNetworkService
import CoreStorageService

import FeatureHomeDIContainer
import FeatureHomeRepository
import FeatureHomeUseCase
import FeatureLoginDIContainer
import FeatureLoginRepository
import FeatureLoginUseCase
import FeatureSettingDIContainer
import FeatureSettingRepository
import FeatureSettingUseCase
import SharedDIContainer
import SharedRepository
import SharedUseCase

import Utils

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
        
        initKakaoAuthSDKInfo()
        initAppleAuthInfo(with: window)
        
        let rootNavigationController = UINavigationController()
        appCoordinator = DefaultAppCoordinator(navigationController: rootNavigationController)
        appCoordinator?.start()
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        KakaoAuthManager.handleLoginUrl(url)
    }
}

// MARK: - KakaoAuthSDK Initialization

private extension SceneDelegate {
    func initKakaoAuthSDKInfo() {
        KakaoAuthManager.initAuthInfo(rightAfter: nil)
    }
    
    func initAppleAuthInfo(with keyWindow: UIWindow?) {
        AppleAuthManager.initAuthInfo(rightAfter: {
            ASAuthorizationControllerProxy.targetWindow = keyWindow
        })
    }
}


// MARK: - Dependency Registration

private extension SceneDelegate {
    func registerAllDependencies() {
        registerCoreDependencies()
        registerSharedDependencies()
        registerLoginDependencies()
        registerHomeDependencies()
        registerSettingDependencies()
    }
    
    func registerCoreDependencies() {
        CoreDIContainer.shared.register(service: AnyDataMapper.self) { AnyDataMapper(CoreExampleDataMapper()) }
        CoreDIContainer.shared.register(service: EndpointService.self) { URLSessionEndpointService.shared }
        CoreDIContainer.shared.register(service: DiskCacheStorage.self) { FileManagerDiskCacheStorage.shared }
        CoreDIContainer.shared.register(service: MemoryCacheStorage.self) { NSCacheMemoryCacheStorage.shared }
    }
    
    func registerSharedDependencies() {
        SharedDIContainer.shared.register(service: NicknameUseCase.self) { DefaultNicknameUseCase() }
        SharedDIContainer.shared.register(service: LoginTypeUseCase.self) { DefaultLoginTypeUseCase() }
        SharedDIContainer.shared.register(service: AutoLoginUseCase.self) { DefaultAutoLoginUseCase() }
        SharedDIContainer.shared.register(service: FeedVisibilityUseCase.self) { DefaultFeedVisibilityUseCase() }
        SharedDIContainer.shared.register(service: ProfileCharacterUseCase.self) { DefaultProfileCharacterUseCase() }
        SharedDIContainer.shared.register(service: UserDefaultsRepository.self) { DefaultUserDefaultsRepository() }
    }
    
    func registerLoginDependencies() {
        LoginDIContainer.shared.register(service: LoginUseCase.self) { DefaultLoginUseCase() }
        LoginDIContainer.shared.register(service: LoginRepository.self) { DefaultLoginRepository() }
    }
    
    func registerHomeDependencies() {
        HomeDIContainer.shared.register(service: HomeUseCase.self) { DefaultHomeUseCase() }
        HomeDIContainer.shared.register(service: HomeRepository.self) { DefaultHomeRepository() }
    }
    
    func registerSettingDependencies() {
        SettingDIContainer.shared.register(service: UserSettingUseCase.self) { DefaultUserSettingUseCase() }
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
