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
        .SPM.RxSwift.package
    ],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Utils).dependency,
        .Project.module(.Features(.StoolLog, .UseCase)).dependency,
        .Project.module(.Features(.StoolLog, .DIContainer)).dependency,
        .SPM.SnapKit.dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxCocoa.dependency
    ]
)
