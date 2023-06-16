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
        case KakaoSDKCommon
        case KakaoSDKAuth
        case KakaoSDKUser
        case Lottie

        public var dependency: TargetDependency {
            switch self {
            case .SnapKit, .Lottie:
                return .package(product: rawValue)
            case .RxSwift, .RxCocoa, .RxRelay:
                return .external(name: rawValue)
            case .KakaoSDKCommon, .KakaoSDKAuth, .KakaoSDKUser:
                return .external(name: rawValue)
            }
        }
        
        public static var allDependencies: [TargetDependency] {
            return [
                Self.SnapKit.dependency,
                Self.RxSwift.dependency,
                Self.RxCocoa.dependency,
                Self.RxRelay.dependency
            ]
        }
    }
}
