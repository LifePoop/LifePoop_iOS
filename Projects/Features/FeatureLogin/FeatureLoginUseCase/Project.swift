//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Login, .UseCase).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Features(.Login, .DIContainer)).dependency,
        .Project.module(.Shared(.SharedDIContainer)).dependency,
        .Project.module(.Shared(.SharedUseCase)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
