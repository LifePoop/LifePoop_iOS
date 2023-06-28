//
//  TargetDependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM: String, CaseIterable {
        case KakaoSDKAuth
        case KakaoSDKCommon
        case KakaoSDKUser
        case Lottie
        case RxCocoa
        case RxRelay
        case RxSwift
        case SnapKit

        public var dependency: TargetDependency {
            switch self {
            case .KakaoSDKCommon, .KakaoSDKAuth, .KakaoSDKUser:
                return .external(name: rawValue)
            case .RxSwift, .RxCocoa, .RxRelay:
                return .external(name: rawValue)
            case .SnapKit, .Lottie:
                return .package(product: rawValue)
            }
        }
        
        public static var allDependencies: [TargetDependency] {
            return [
                Self.RxCocoa.dependency,
                Self.RxRelay.dependency,
                Self.RxSwift.dependency,
                Self.SnapKit.dependency
            ]
        }
    }
}
