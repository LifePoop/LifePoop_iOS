//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Home, .Coordinator).name,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Features(.Home, .Presentation)).dependency,
        .Project.module(.Features(.Home, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.StoolLog, .Coordinator)).dependency
        .Project.module(.Utils).dependency,
    ],
    hasTests: false
)
