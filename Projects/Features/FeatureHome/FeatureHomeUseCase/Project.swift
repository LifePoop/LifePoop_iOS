//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Home, .UseCase).name,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Features(.Home, .DIContainer)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)