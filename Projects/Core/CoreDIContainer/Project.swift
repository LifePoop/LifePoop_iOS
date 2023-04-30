//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/27.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Core(.CoreDIContainer).name,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxRelay.dependency
    ],
    hasTests: false
)