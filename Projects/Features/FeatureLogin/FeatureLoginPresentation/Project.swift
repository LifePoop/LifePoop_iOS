//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Login, .Presentation).name,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.DesignSystemReactive).dependency,
        .Project.module(.EntityUIMapper).dependency,
        .Project.module(.DesignSystem).dependency,
        .Project.module(.EntityUIMapper).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .Project.module(.Features(.Login, .UseCase)).dependency,
        .Project.module(.Features(.Login, .DIContainer)).dependency,
        .Project.module(.Features(.Login, .CoordinatorInterface)).dependency,
        .SPM.SnapKit.dependency,
        .SPM.Lottie.dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxCocoa.dependency
    ]
)
