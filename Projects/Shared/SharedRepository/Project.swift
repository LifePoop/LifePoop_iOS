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
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreDataMapper)).dependency,
        .Project.module(.Core(.CoreDIContainer)).dependency,
        .Project.module(.Core(.CoreDTO)).dependency,
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Core(.CoreError)).dependency,
        .Project.module(.Core(.CoreExtension)).dependency,
        .Project.module(.Core(.CoreNetworkService)).dependency,
        .Project.module(.Core(.CoreStorageService)).dependency,
        .Project.module(.Core(.CoreTarget)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ]
)
