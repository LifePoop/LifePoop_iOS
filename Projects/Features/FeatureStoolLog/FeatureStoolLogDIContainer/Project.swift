//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이준우 on 2023/05/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.StoolLog, .DIContainer).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Utils).dependency
    ],
    hasTests: false
)
