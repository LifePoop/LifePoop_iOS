//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/06/08.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Report, .Coordinator).name,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.module(.Logger).dependency,
        .Project.module(.Features(.Report, .Presentation)).dependency,
        .Project.module(.Features(.Report, .CoordinatorInterface)).dependency,
        .Project.module(.Utils).dependency,
    ],
    hasTests: false
)
