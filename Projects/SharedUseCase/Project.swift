//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/28.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.SharedUseCase.name,
    product: .framework,
    packages: [
        .SPM.RxSwift
    ],
    dependencies: [
        .Project.CoreDIContainer,
        .Project.CoreEntity,
        .Project.Logger,
        .Project.Utils,
        .SPM.RxSwift
    ]
)
