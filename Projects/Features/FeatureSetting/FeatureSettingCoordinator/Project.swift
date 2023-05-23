//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Setting, .Coordinator).name,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Features(.Setting, .Presentation)).dependency,
        .Project.module(.Features(.Setting, .CoordinatorInterface)).dependency,
        .Project.module(.Utils).dependency,
    ],
    hasTests: false
)
