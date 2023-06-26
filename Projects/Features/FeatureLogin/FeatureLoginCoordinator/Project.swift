//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Login, .Coordinator).name,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Features(.Login, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.Login, .Presentation)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
    ],
    hasTests: false
)
