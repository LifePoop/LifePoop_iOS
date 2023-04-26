//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Features.Login.containerName,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.Utils,
        .Project.FeatureLoginData,
        .Project.FeatureLoginDomain,
        .Project.FeatureLoginPresentation
    ],
    hasTests: false
)
