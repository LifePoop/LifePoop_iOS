//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Lee, Joon Woo on 2023/06/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.FriendList, .UseCase).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Features(.FriendList, .DIContainer)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Shared(.SharedDIContainer)).dependency,
        .Project.module(.Shared(.SharedUseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
