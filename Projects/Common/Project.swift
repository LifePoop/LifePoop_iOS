//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Common",
    product: .framework,
    packages: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0"))
    ],
    dependencies: [
        .package(product: "RxSwift"),
        .package(product: "RxCocoa"),
        .package(product: "RxRelay")
    ],
    hasTests: false
)
