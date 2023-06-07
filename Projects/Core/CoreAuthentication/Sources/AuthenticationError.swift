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
    case kakaoTalkLoginNotAvailable
    case authTokenNil
    
    public var errorDescription: String? {
        switch self {
        case .authInfoNotInitialized:
            return "인증 정보가 초기화되지 않았습니다."
        case .kakaoTalkLoginNotAvailable:
            return "카카오 로그인이 현재 불가합니다."
        case .authTokenNil:
            return "인증 토큰이 존재하지 않습니다.(nil value)"
        }
    }
}
