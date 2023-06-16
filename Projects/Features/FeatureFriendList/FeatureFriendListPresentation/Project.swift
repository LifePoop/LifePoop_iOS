//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Lee, Joon Woo on 2023/06/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.FriendList, .Presentation).name,
    product: .staticFramework,
    packages: [
        .SPM.SnapKit.package
    ],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.DesignSystem).dependency,
        .Project.module(.DesignSystemReactive).dependency,
        .Project.module(.EntityUIMapper).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .Project.module(.Features(.FriendList, .UseCase)).dependency,
        .Project.module(.Features(.FriendList, .DIContainer)).dependency,
        .Project.module(.Features(.FriendList, .CoordinatorInterface)).dependency,
        .SPM.SnapKit.dependency,
        .SPM.RxSwift.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxCocoa.dependency,
    ],
    hasTests: false
)
