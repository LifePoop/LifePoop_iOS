//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이준우 on 2023/05/03.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.StoolLog, .Presentation).name,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit.package,
    ],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.DesignSystem).dependency,
        .Project.module(.DesignSystemReactive).dependency,
        .Project.module(.EntityUIMapper).dependency,
        .Project.module(.Features(.StoolLog, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.StoolLog, .DIContainer)).dependency,
        .Project.module(.Features(.StoolLog, .UseCase)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxSwift.dependency,
        .SPM.SnapKit.dependency
    ]
)
