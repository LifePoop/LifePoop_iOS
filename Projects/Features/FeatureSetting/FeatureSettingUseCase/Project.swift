//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Setting, .UseCase).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Features(.Setting, .DIContainer)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
