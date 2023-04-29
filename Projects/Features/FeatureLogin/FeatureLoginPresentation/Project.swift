//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Login, .presentation).name,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit.package,
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Utils).dependency,
        .Project.module(.Features(.Login, .useCase)).dependency,
        .Project.module(.Features(.Login, .diContainer)).dependency,
        .SPM.SnapKit.dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxCocoa.dependency
    ]
)
