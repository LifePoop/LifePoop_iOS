//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/28.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.SharedRepository.name,
    product: .framework,
    packages: [
        .SPM.RxSwift
    ],
    dependencies: [
        .Project.CoreDataMapper,
        .Project.CoreDIContainer,
        .Project.CoreDTO,
        .Project.CoreEntity,
        .Project.CoreError,
        .Project.CoreExtension,
        .Project.CoreNetworkService,
        .Project.CoreStorageService,
        .Project.CoreTarget,
        .Project.Utils,
        .SPM.RxSwift
    ]
)
