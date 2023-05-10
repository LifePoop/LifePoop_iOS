//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public enum Modules {
    case App
    case DesignSystem
    case Logger
    case Utils
    case Shared(SharedModuleType)
    case Features(FeatureModuleType, FeatureLayerModuleType)
    case Core(CoreModuleType)
    
    public var name: String {
        switch self {
        case .App:
            return "App"
        case .DesignSystem:
            return "DesignSystem"
        case .Logger:
            return "Logger"
        case .Utils:
            return "Utils"
        case .Shared(let shared):
            return shared.rawValue
        case .Features(let featureModule, let featureLayerModule):
            return "Feature\(featureModule.rawValue)\(featureLayerModule.rawValue)"
        case .Core(let core):
            return core.rawValue
        }
    }
    
    public var path: String {
        switch self {
        case .App, .DesignSystem, .Logger, .Utils:
            return "Projects/\(name)"
        case .Shared:
            return "Projects/Shared/\(name)"
        case .Features(let featureModule, _):
            return "Projects/Features/Feature\(featureModule.rawValue)/\(name)"
        case .Core:
            return "Projects/Core/\(name)"
        }
    }
}

public enum SharedModuleType: String, CaseIterable {
    case SharedRepository
    case SharedUseCase
}

public enum FeatureModuleType: String, CaseIterable {
    case Login
    case Home
    case StoolLog
    
    var layerModules: [FeatureLayerModuleType] {
        switch self {
        case .Login:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        case .Home:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        case .StoolLog:
            return [.DIContainer, .Coordinator, .CoordinatorInterface, .Presentation, .UseCase, .Repository]
        }
    }
}

public enum FeatureLayerModuleType: String, CaseIterable {
    case DIContainer
    case Coordinator
    case CoordinatorInterface
    case Presentation
    case UseCase
    case Repository
}

public enum CoreModuleType: String, CaseIterable {
    case CoreDIContainer
    case CoreEntity
    case CoreNetworkService
    case CoreStorageService
}
