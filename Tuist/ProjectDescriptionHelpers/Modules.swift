//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public enum Modules {
    case App
    case Core(CoreModuleType)
    case DesignSystem
    case DesignSystemReactive
    case EntityUIMapper
    case Features(FeatureModuleType, FeatureLayerModuleType)
    case Logger
    case Shared(SharedModuleType)
    case Utils
    
    public var name: String {
        switch self {
        case .App:
            return "App"
        case .Core(let core):
            return core.rawValue
        case .DesignSystem:
            return "DesignSystem"
        case .DesignSystemReactive:
            return "DesignSystemReactive"
        case .EntityUIMapper:
            return "EntityUIMapper"
        case .Features(let featureModule, let featureLayerModule):
            return "Feature\(featureModule.rawValue)\(featureLayerModule.rawValue)"
        case .Logger:
            return "Logger"
        case .Shared(let shared):
            return shared.rawValue
        case .Utils:
            return "Utils"
        }
    }
    
    public var path: String {
        switch self {
        case .App, .DesignSystem, .DesignSystemReactive, .EntityUIMapper, .Logger, .Utils:
            return "Projects/\(name)"
        case .Core:
            return "Projects/Core/\(name)"
        case .Features(let featureModule, _):
            return "Projects/Features/Feature\(featureModule.rawValue)/\(name)"
        case .Shared:
            return "Projects/Shared/\(name)"
        }
    }
}

public enum SharedModuleType: String, CaseIterable {
    case SharedDIContainer
    case SharedRepository
    case SharedUseCase
}

public enum FeatureModuleType: String, CaseIterable {
    case FriendList
    case Home
    case Login
    case Report
    case Setting
    case StoolLog
    
    var layerModules: [FeatureLayerModuleType] {
        switch self {
        case .FriendList:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        case .Home:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        case .Login:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        case .Report:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        case .Setting:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        case .StoolLog:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        }
    }
}

public enum FeatureLayerModuleType: String, CaseIterable {
    case Coordinator
    case CoordinatorInterface
    case DIContainer
    case Presentation
    case Repository
    case UseCase
}

public enum CoreModuleType: String, CaseIterable {
    case CoreAuthentication
    case CoreDIContainer
    case CoreEntity
    case CoreNetworkService
    case CoreStorageService
}
