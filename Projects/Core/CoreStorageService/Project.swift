//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Core.CoreStorageService.name,
    product: .framework,
    packages: [
        .SPM.RxSwift
    ],
    dependencies: [
        .Project.CoreComponent,
        .Project.CoreError,
        .Project.CoreExtension,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay
    ],
    hasTests: false
)
