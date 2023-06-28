//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Setting, .Presentation).name,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.DesignSystem).dependency,
        .Project.module(.DesignSystemReactive).dependency,
        .Project.module(.EntityUIMapper).dependency,
        .Project.module(.Features(.Setting, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.Setting, .DIContainer)).dependency,
        .Project.module(.Features(.Setting, .UseCase)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Shared(.SharedDIContainer)).dependency,
        .Project.module(.Shared(.SharedUseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxSwift.dependency,
        .SPM.SnapKit.dependency
    ]
)
