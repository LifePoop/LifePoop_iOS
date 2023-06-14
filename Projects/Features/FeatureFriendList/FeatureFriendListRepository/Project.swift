//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Lee, Joon Woo on 2023/06/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Features(.FriendList, .Repository).name,
    product: .framework,
    packages: [],
    dependencies: [
        .Project.module(.Core(.CoreAuthentication)).dependency,
        .Project.module(.Core(.CoreDIContainer)).dependency,
        .Project.module(.Core(.CoreEntity)).dependency,
        .Project.module(.Core(.CoreNetworkService)).dependency,
        .Project.module(.Features(.FriendList, .UseCase)).dependency,
        .Project.module(.Utils).dependency,
        .SPM.RxSwift.dependency
    ],
    hasTests: false
)

