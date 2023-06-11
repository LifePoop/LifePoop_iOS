//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/06/08.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Report, .CoordinatorInterface).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Utils).dependency,
    ],
    hasTests: false
)
