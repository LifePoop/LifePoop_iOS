//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.CoreDTO.name,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay
    ],
    hasTests: false
)
