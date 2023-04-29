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
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreComponent)).dependency,
        .Project.module(.Core(.CoreError)).dependency,
        .Project.module(.Core(.CoreExtension)).dependency,
        .Project.module(.Core(.CoreTarget)).dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxRelay.dependency
    ],
    hasTests: false
)
