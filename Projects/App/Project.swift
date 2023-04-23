//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.app.name,
    platform: .iOS,
    product: .app,
    dependencies: [
        .Project.Common,
        .Project.Coordinator,
        .Project.Data,
        .Project.Domain,
        .Project.Presentation
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Attributes/Info.plist"),
    hasTests: false
)
