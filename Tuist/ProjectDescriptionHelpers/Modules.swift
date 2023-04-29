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
        case .Features(let features, let featureLayer):
            switch featureLayer {
            case .presentation:
                return "Feature\(features.rawValue)Presentation"
            case .useCase:
                return "Feature\(features.rawValue)UseCase"
            case .repository:
                return "Feature\(features.rawValue)Repository"
            case .diContainer:
                return "Feature\(features.rawValue)DIContainer"
            }
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
        case .Features(let features, _):
            return "Projects/Features/Feature\(features.rawValue)/\(name)"
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
}

public enum FeatureLayerModuleType: CaseIterable {
    case presentation
    case useCase
    case repository
    case diContainer
}

public enum CoreModuleType: String, CaseIterable {
    case CoreComponent
    case CoreDataMapper
    case CoreDIContainer
    case CoreDTO
    case CoreEntity
    case CoreError
    case CoreExtension
    case CoreNetworkService
    case CoreStorageService
    case CoreTarget
}
