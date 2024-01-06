//
//  AuthenticationError.swift
//  FeatureLoginRepository
//
//  Created by Lee, Joon Woo on 2023/05/25.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum AuthenticationError: LocalizedError {
    case authInfoNotInitialized
    case appleLoginViewClosed
    case authTokenNil
    
    public var errorDescription: String? {
        switch self {
        case .authInfoNotInitialized:
            return "인증 정보가 초기화되지 않았습니다."
        case .appleLoginViewClosed:
            return "사용자가 임의로 애플 로그인 창을 닫은 상태"
        case .authTokenNil:
            return "인증 토큰이 존재하지 않습니다.(nil value)"
        }
    }
}
