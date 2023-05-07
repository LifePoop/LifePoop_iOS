//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이준우 on 2023/05/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.StoolLog, .Repository).name,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreDIContainer)).dependency,
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Core(.CoreNetworkService)).dependency,
        .Project.module(.Features(.StoolLog, .UseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
