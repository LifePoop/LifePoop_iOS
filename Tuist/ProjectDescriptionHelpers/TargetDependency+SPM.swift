//
//  TargetDependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM: String, CaseIterable {
        case SnapKit
        case RxSwift
        case RxCocoa
        case RxRelay
        
        public var dependency: TargetDependency {
            return .package(product: rawValue)
        }
        
        public static var allDependencies: [TargetDependency] {
            return Self.allCases.map { $0.dependency }
        }
    }
}
