//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/06/08.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Report, .Presentation).name,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.DesignSystem).dependency,
        .Project.module(.DesignSystemReactive).dependency,
        .Project.module(.EntityUIMapper).dependency,
        .Project.module(.Features(.Report, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.Report, .DIContainer)).dependency,
        .Project.module(.Features(.Report, .UseCase)).dependency,
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
