//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Presentation",
    product: .framework,
    packages: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0"))
    ],
    dependencies: [
        .project(target: "Common", path: .relativeToRoot("Projects/Common")),
        .project(target: "Domain", path: .relativeToRoot("Projects/Domain")),
        .package(product: "SnapKit"),
        .package(product: "RxSwift"),
        .package(product: "RxCocoa"),
        .package(product: "RxRelay")
    ],
    resources: ["Resources/**"]
)
