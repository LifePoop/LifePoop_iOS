//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.Home, .Coordinator).name,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Features(.FriendList, .Coordinator)).dependency,
        .Project.module(.Features(.FriendList, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.Home, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.Home, .Presentation)).dependency,
        .Project.module(.Features(.Report, .Presentation)).dependency,
        .Project.module(.Features(.Setting, .Coordinator)).dependency,
        .Project.module(.Features(.Setting, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.StoolLog, .Coordinator)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxRelay.dependency,
        .SPM.RxSwift.dependency
    ],
    hasTests: false
)
