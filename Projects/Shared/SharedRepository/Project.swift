//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/28.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Shared(.SharedRepository).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreAuthentication)).dependency,
        .Project.module(.Core(.CoreDIContainer)).dependency,
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Core(.CoreNetworkService)).dependency,
        .Project.module(.Core(.CoreStorageService)).dependency,
        .Project.module(.Shared(.SharedUseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
