//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.StoolLog, .CoordinatorInterface).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Utils).dependency
    ],
    hasTests: false
)
