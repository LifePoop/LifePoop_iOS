//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.App.name,
    platform: .iOS,
    product: .app,
    dependencies: [
        .Project.DesignSystem,
        .Project.Logger,
        .Project.Utils,
        
        .Project.FeatureLoginContainer,
        .Project.FeatureLoginData,
        .Project.FeatureLoginDomain,
        .Project.FeatureLoginPresentation,
        
        .Project.CoreComponent,
        .Project.CoreDataMapper,
        .Project.CoreDTO,
        .Project.CoreEntity,
        .Project.CoreError,
        .Project.CoreExtension,
        .Project.CoreStorageService,
        .Project.CoreNetworkService,
        .Project.CoreTarget,
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Attributes/Info.plist"),
    hasTests: false
)
