//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/06/08.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Report, .Repository).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreDIContainer)).dependency,
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Core(.CoreNetworkService)).dependency,
        .Project.module(.Features(.Report, .UseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
