//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Setting, .CoordinatorInterface).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxRelay.dependency
    ],
    hasTests: false
)
