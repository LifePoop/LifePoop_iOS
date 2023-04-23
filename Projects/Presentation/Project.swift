//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.presentation.name,
    product: .framework,
    packages: [
        .SPM.SnapKit,
        .SPM.RxSwift
    ],
    dependencies: [
        .Project.Common,
        .Project.Domain,
        .SPM.SnapKit,
        .SPM.RxSwift,
        .SPM.RxRelay,
        .SPM.RxCocoa
    ],
    resources: ["Resources/**"]
)
