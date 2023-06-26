//
//  Package+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public extension Package {
    enum SPM: CaseIterable {
        case Lottie
        case SnapKit

        public var package: Package {
            switch self {
            case .Lottie:
                return .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.2.0")
            case .SnapKit:
                return .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0"))
            }
        }

        public static var allPackages: [Package] {
            return allCases.map { $0.package }
        }
    }
}
