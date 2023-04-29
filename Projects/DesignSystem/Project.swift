//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.DesignSystem.name,
    product: .framework,
    packages: [],
    dependencies: [],
    resources: ["Resources/**"],
    hasTests: false
)
