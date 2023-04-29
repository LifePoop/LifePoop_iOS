//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

let packages = Package.SPM.allPackages

let project = Project.makeModule(
    name: Module.App.name,
    platform: .iOS,
    product: .app,
    packages: packages,
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxRelay,
        .SPM.RxCocoa,
        .SPM.SnapKit,
        
        .Project.DesignSystem,
        .Project.Logger,
        .Project.Utils,
        
        .Project.SharedRepository,
        .Project.SharedUseCase,
        
        .Project.FeatureLoginDIContainer,
        .Project.FeatureLoginData,
        .Project.FeatureLoginDomain,
        .Project.FeatureLoginPresentation,
        
        .Project.CoreComponent,
        .Project.CoreDataMapper,
        .Project.CoreDIContainer,
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
