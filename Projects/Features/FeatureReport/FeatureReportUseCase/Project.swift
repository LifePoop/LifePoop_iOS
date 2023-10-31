//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/06/08.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Report, .UseCase).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Features(.Report, .DIContainer)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Shared(.SharedDIContainer)).dependency,
        .Project.module(.Shared(.SharedUseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
