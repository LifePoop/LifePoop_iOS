//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.StoolLog, .Coordinator).name,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Features(.StoolLog, .Presentation)).dependency,
        .Project.module(.Features(.StoolLog, .CoordinatorInterface)).dependency,
        .Project.module(.Utils).dependency,
    ],
    hasTests: false
)
