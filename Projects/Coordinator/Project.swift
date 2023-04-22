//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Coordinator",
    product: .framework,
    packages: [],
    dependencies: [
        .project(target: "Common", path: .relativeToRoot("Projects/Common")),
        .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation"))
    ]
)
