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
            .debug(
                name: "Debug",
                settings: SettingsDictionary()
                    .manualCodeSigning(
                        identity: "Apple Development",
                        provisioningProfileSpecifier: "match Development com.Lifepoo.App"
                    ),
                xcconfig: "./xcconfigs/\(Modules.App.name).base.xcconfig"
            ),
            .release(
                name: "Release",
                settings: SettingsDictionary()
                    .manualCodeSigning(
                        identity: "Apple Distribution",
                        provisioningProfileSpecifier: "match AppStore com.Lifepoo.App"
                    ),
                xcconfig: "./xcconfigs/\(Modules.App.name).base.xcconfig"
            )
        ]
    ),
    hasTests: false
)
