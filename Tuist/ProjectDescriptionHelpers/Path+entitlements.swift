//
//  Path+entitlements.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/07/05.
//

import ProjectDescription

public extension Path {
    static func entitlementsPath(for module: Modules) -> Path {
        return Path("\(module.name).entitlements")
    }
}
