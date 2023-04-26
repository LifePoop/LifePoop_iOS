//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.Features.Login.presentationName,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit,
        .SPM.RxSwift
    ],
    dependencies: [
        .Project.Utils,
        .Project.DesignSystem,
        .Project.FeatureLoginDomain,
        .SPM.SnapKit,
        .SPM.RxSwift,
        .SPM.RxRelay,
        .SPM.RxCocoa
    ]
)
