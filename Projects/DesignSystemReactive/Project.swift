//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/06/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.DesignSystemReactive.name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxSwift.dependency,
    ],
    hasTests: false
)
