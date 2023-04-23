//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//
import ProjectDescription

public extension TargetScript {
    static let SwiftLintShell = TargetScript.pre(
        path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLintShell"
    )
}
