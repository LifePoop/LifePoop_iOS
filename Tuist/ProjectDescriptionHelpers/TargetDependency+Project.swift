//
//  TargetDependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public extension TargetDependency {
    enum Project {
        case module(Modules)
        
        public var dependency: TargetDependency {
            switch self {
            case .module(let module):
                return .project(target: module.name, path: .relativeToRoot(module.path))
            }
        }
        
        public static var allDependencies: [TargetDependency] {
            let sharedDependencies = SharedModuleType.allCases.map { Project.module(.Shared($0)).dependency }
            let featureDependencies = FeatureModuleType.allCases.flatMap { feature in
                FeatureLayerModuleType.allCases.map { Project.module(.Features(feature, $0)).dependency }
            }
            let coreDependencies = CoreModuleType.allCases.map { Project.module(.Core($0)).dependency }
            
            return [
                Project.module(.DesignSystem).dependency,
                Project.module(.Logger).dependency,
                Project.module(.Utils).dependency
            ] + sharedDependencies + featureDependencies + coreDependencies
        }
    }
}
