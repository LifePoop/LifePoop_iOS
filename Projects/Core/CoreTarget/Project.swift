//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.CoreTarget.name,
    product: .framework,
    packages: [
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.CoreComponent,
        .Project.Utils,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay
    ],
    hasTests: false
)
