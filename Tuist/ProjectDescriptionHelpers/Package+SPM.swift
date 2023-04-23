//
//  Package+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public extension Package {
    enum SPM { }
}

public extension Package.SPM {
    static let SnapKit = Package.package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0"))
    static let RxSwift = Package.package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0"))
}
