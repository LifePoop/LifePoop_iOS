//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Utils.name,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .SPM.RxSwift.dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxRelay.dependency
    ],
    hasTests: false
)
