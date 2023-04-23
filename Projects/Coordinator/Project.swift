//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.coordinator.name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.Common,
        .Project.Presentation
    ]
)
