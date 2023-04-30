//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Login, .Repository).name,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreDataMapper)).dependency,
        .Project.module(.Core(.CoreDIContainer)).dependency,
        .Project.module(.Core(.CoreDTO)).dependency,
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Core(.CoreExtension)).dependency,
        .Project.module(.Core(.CoreNetworkService)).dependency,
        .Project.module(.Core(.CoreTarget)).dependency,
        .Project.module(.Features(.Login, .UseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
