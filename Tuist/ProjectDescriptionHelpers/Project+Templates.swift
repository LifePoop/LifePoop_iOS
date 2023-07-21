//
//  Project+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/22.
//

import ProjectDescription

public extension Project {
    static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        organizationName: String = "Lifepoo",
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "15.0", devices: [.iphone]),
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default,
        entitlements: Path? = nil,
        settings: Settings? = nil,
        additionalFiles: [FileElement] = [],
        hasTests: Bool = true
    ) -> Project {
        let appTarget = makeTarget(
            name: name,
            platform: platform,
            product: product,
            bundleIdSuffix: organizationName,
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            dependencies: dependencies,
            settings: settings
        )
        
        let testTarget = makeTestTarget(
            name: name,
            platform: platform,
            bundleIdSuffix: organizationName,
            deploymentTarget: deploymentTarget,
            dependencyName: name
        )
        
        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
        let targets: [Target] = hasTests ? [appTarget, testTarget] : [appTarget]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            additionalFiles: additionalFiles
        )
    }
    
    static func makeTarget(
        name: String,
        platform: Platform,
        product: Product,
        bundleIdSuffix: String,
        deploymentTarget: DeploymentTarget?,
        infoPlist: InfoPlist,
        sources: SourceFilesList,
        resources: ResourceFileElements?,
        entitlements: Path?,
        dependencies: [TargetDependency],
        settings: Settings?
    ) -> Target {
        return Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "com.\(bundleIdSuffix).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            scripts: [.SwiftLintShell],
            dependencies: dependencies,
            settings: settings
        )
    }
    
    static func makeTestTarget(
        name: String,
        platform: Platform,
        bundleIdSuffix: String,
        deploymentTarget: DeploymentTarget?,
        dependencyName: String
    ) -> Target {
        return Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "com.\(bundleIdSuffix).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: dependencyName)]
        )
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
