//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Core(.CoreNetworkService).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxSwift.dependency
    ],
    hasTests: false
)
