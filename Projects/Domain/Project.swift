//
//  Projects.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.domain.name,
    product: .framework,
    packages: [
        .SPM.RxSwift
    ],
    dependencies: [
        .Project.Common,
        .SPM.RxSwift
    ]
)
