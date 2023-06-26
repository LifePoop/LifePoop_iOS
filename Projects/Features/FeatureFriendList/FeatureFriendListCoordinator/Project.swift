//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Lee, Joon Woo on 2023/06/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.FriendList, .Coordinator).name,
    product: .staticFramework,
    packages: [],
    dependencies: [
        .Project.module(.DesignSystem).dependency,
        .Project.module(.Features(.FriendList, .CoordinatorInterface)).dependency,
        .Project.module(.Features(.FriendList, .Presentation)).dependency,
        .Project.module(.Logger).dependency,
        .Project.module(.Utils).dependency,
    ],
    hasTests: false
)
