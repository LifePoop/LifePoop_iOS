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
    case kakaoLoginCancelledByUser
    case appleLoginCancelledByUser
    case authTokenNil
    
    public var errorDescription: String? {
        switch self {
        case .authInfoNotInitialized:
            return "인증 정보가 초기화되지 않았습니다."
        case .kakaoLoginCancelledByUser:
            return "사용자가 카카오 로그인을 취소한 상태"
        case .appleLoginCancelledByUser:
            return "사용자가 애플 로그인을 취소한 상태"
        case .authTokenNil:
            return "인증 토큰이 존재하지 않습니다.(nil value)"
        }
    }
}
