//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "App",
    platform: .iOS,
    product: .app,
    dependencies: [
        .project(target: "Common", path: .relativeToRoot("Projects/Common")),
        .project(target: "Coordinator", path: .relativeToRoot("Projects/Coordinator")),
        .project(target: "Data", path: .relativeToRoot("Projects/Data")),
        .project(target: "Domain", path: .relativeToRoot("Projects/Domain")),
        .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation"))
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Attributes/Info.plist"),
    hasTests: false
)
