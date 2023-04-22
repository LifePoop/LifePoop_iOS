//
//  Projects.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Domain",
    product: .framework,
    packages: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0"))
    ],
    dependencies: [
        .project(target: "Common", path: .relativeToRoot("Projects/Common")),
        .package(product: "RxSwift")
    ]
)
