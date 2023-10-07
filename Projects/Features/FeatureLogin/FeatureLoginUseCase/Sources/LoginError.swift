//
//  LoginError.swift
//  FeatureLoginUseCase
//
//  Created by Lee, Joon Woo on 2023/10/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum LoginError: Error, CustomStringConvertible {
    
    case oAuthLoginFailed
    case userNotExists
    case failedFetchingUserInfo
    case updatedAuthInfoNil
    case otherNetworkError(error: Error)
    
    public var description: String {
        switch self {
        case .oAuthLoginFailed:
            return "소셜 로그인 실패"
        case .userNotExists:
            return "해당 사용자가 존재하지 않음. 회원가입 필요"
        case .failedFetchingUserInfo:
            return "사용자 정보 불러오기 실패"
        case .updatedAuthInfoNil:
            return "업데이트된 인증정보가 존재하지 않음. Repository 리턴값 재확인 필요"
        case .otherNetworkError(let error):
            return "알 수 없는 네트워크 에러\n(\(error))"
        }
    }
}
