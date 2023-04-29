//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Features.Login.useCaseName,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.CoreEntity,
        .Project.FeatureLoginDIContainer,
        .Project.Logger,
        .Project.Utils,
        .SPM.RxSwift,
    ]
)
