//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/05/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
        .remote(
            url: "https://github.com/ReactiveX/RxSwift.git",
            requirement: .upToNextMajor(from: "6.5.0")
        ),
        .remote(
            url: "https://github.com/kakao/kakao-ios-sdk",
            requirement: .upToNextMajor(from: "2.15.0")
        )
    ],
    platforms: [.iOS]
)
