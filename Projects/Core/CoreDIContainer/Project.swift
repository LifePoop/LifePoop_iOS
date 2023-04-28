//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/27.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.CoreDIContainer.name,
    product: .framework,
    packages: [
        .SPM.RxSwift
    ],
    dependencies: [
        .Project.Utils,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay
    ],
    hasTests: false
)
