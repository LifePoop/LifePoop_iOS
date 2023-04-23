//
//  TargetDependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM { }
}

public extension TargetDependency.SPM {
    static let SnapKit = TargetDependency.package(product: "SnapKit")
    static let RxSwift = TargetDependency.package(product: "RxSwift")
    static let RxCocoa = TargetDependency.package(product: "RxCocoa")
    static let RxRelay = TargetDependency.package(product: "RxRelay")
}
