//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/28.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Shared(.SharedUseCase).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Shared(.SharedDIContainer)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
