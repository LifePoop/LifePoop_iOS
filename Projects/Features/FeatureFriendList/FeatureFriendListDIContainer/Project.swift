//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Lee, Joon Woo on 2023/06/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.FriendList, .DIContainer).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Utils).dependency
    ],
    hasTests: false
)
