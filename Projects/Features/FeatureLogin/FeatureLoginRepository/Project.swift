//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Features.Login.repositoryName,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.CoreDataMapper,
        .Project.CoreDIContainer,
        .Project.CoreDTO,
        .Project.CoreEntity,
        .Project.CoreExtension,
        .Project.CoreNetworkService,
        .Project.CoreTarget,
        .Project.FeatureLoginDomain,
        .Project.Utils,
        .SPM.RxSwift
    ]
)
