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
    static let Common = TargetDependency.project(target: Module.common.name, path: .relativeToRoot(Module.common.path))
    static let Coordinator = TargetDependency.project(target: Module.coordinator.name, path: .relativeToRoot(Module.coordinator.path))
    static let Data = TargetDependency.project(target: Module.data.name, path: .relativeToRoot(Module.data.path))
    static let Domain = TargetDependency.project(target: Module.domain.name, path: .relativeToRoot(Module.domain.path))
    static let Presentation = TargetDependency.project(target: Module.presentation.name, path: .relativeToRoot(Module.presentation.path))
}
