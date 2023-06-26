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
        .Project.module(.Features(.FriendList, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.FriendList, .DIContainer)).dependency,
        .Project.module(.Features(.FriendList, .UseCase)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxCocoa.dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxSwift.dependency,
        .SPM.SnapKit.dependency,
    ],
    hasTests: false
)
