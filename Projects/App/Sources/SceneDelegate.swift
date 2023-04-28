//
//  SceneDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/22.
//

import UIKit

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
        
        let rootNavigationController = UINavigationController()
        appCoordinator = DefaultAppCoordinator(navigationController: rootNavigationController)
        appCoordinator?.start()
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}
