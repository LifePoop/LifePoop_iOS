//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/19.
//
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.App.name,
    platform: .iOS,
    product: .app,
    packages: Package.SPM.allPackages,
    dependencies: TargetDependency.SPM.allDependencies + TargetDependency.Project.allDependencies,
    resources: ["Resources/**"],
    infoPlist: .file(path: "Attributes/Info.plist"),
    entitlements: .entitlementsPath(for: .App),
    settings: .settings(
      configurations: [
        .debug(name: .debug, xcconfig: "./xcconfigs/\(Modules.App.name).debug.xcconfig"),
        .release(name: .release, xcconfig: "./xcconfigs/\(Modules.App.name).release.xcconfig"),
      ]
    ),
    hasTests: false
)
