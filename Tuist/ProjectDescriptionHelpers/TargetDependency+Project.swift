//
//  TargetDependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public extension TargetDependency {
    enum Project { }
}

public extension TargetDependency.Project {
    static let DesignSystem = TargetDependency.project(
        target: Module.DesignSystem.name,
        path: .relativeToRoot(Module.DesignSystem.path)
    )
    static let Logger = TargetDependency.project(
        target: Module.Logger.name,
        path: .relativeToRoot(Module.Logger.path)
    )
    static let Utils = TargetDependency.project(
        target: Module.Utils.name,
        path: .relativeToRoot(Module.Utils.path)
    )
    
    // MARK: - Core
    
    static let CoreComponent = TargetDependency.project(
        target: Module.Core.CoreComponent.name,
        path: .relativeToRoot(Module.Core.CoreComponent.path)
    )
    static let CoreDataMapper = TargetDependency.project(
        target: Module.Core.CoreDataMapper.name,
        path: .relativeToRoot(Module.Core.CoreDataMapper.path)
    )
    static let CoreDTO = TargetDependency.project(
        target: Module.Core.CoreDTO.name,
        path: .relativeToRoot(Module.Core.CoreDTO.path)
    )
    static let CoreEntity = TargetDependency.project(
        target: Module.Core.CoreEntity.name,
        path: .relativeToRoot(Module.Core.CoreEntity.path)
    )
    static let CoreError = TargetDependency.project(
        target: Module.Core.CoreError.name,
        path: .relativeToRoot(Module.Core.CoreError.path)
    )
    static let CoreExtension = TargetDependency.project(
        target: Module.Core.CoreExtension.name,
        path: .relativeToRoot(Module.Core.CoreExtension.path)
    )
    static let CoreNetworkService = TargetDependency.project(
        target: Module.Core.CoreNetworkService.name,
        path: .relativeToRoot(Module.Core.CoreNetworkService.path)
    )
    static let CoreStorageService = TargetDependency.project(
        target: Module.Core.CoreStorageService.name,
        path: .relativeToRoot(Module.Core.CoreStorageService.path)
    )
    static let CoreTarget = TargetDependency.project(
        target: Module.Core.CoreTarget.name,
        path: .relativeToRoot(Module.Core.CoreTarget.path)
    )
    
    // MARK: - Features
    
    /// Login
    static let FeatureLoginContainer = TargetDependency.project(
        target: Module.Features.Login.containerName,
        path: .relativeToRoot(Module.Features.Login.containerPath)
    )
    static let FeatureLoginData = TargetDependency.project(
        target: Module.Features.Login.repositoryName,
        path: .relativeToRoot(Module.Features.Login.repositoryPath)
    )
    static let FeatureLoginDomain = TargetDependency.project(
        target: Module.Features.Login.useCaseName,
        path: .relativeToRoot(Module.Features.Login.useCasePath)
    )
    static let FeatureLoginPresentation = TargetDependency.project(
        target: Module.Features.Login.presentationName,
        path: .relativeToRoot(Module.Features.Login.presentationPath)
    )
}
