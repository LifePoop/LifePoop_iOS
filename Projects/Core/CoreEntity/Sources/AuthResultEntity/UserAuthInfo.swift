//
//  UserAuthInfo.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Utils

public struct UserAuthInfo: Codable {

    let loginType: LoginType?
    let authToken: AccessTokenPossessable?

    enum CodingKeys: String, CodingKey {
        case authToken
        case loginType
    }

    public init(loginType: LoginType, authToken: AccessTokenPossessable) {
        self.loginType = loginType
        self.authToken = authToken
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawLoginType = try container.decode(String.self, forKey: .loginType)
        self.loginType = LoginType(rawValue: rawLoginType) ?? .none

        switch self.loginType {
        case .apple:
            self.authToken = try container.decode(AppleAuthResultEntity.self, forKey: .authToken)
        case .kakao:
            self.authToken = try container.decode(KakaoAuthResultEntity.self, forKey: .authToken)
        default:
            self.authToken = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(loginType?.rawValue ?? "", forKey: .loginType)
        
        if let kakaoAuthToken = authToken as? KakaoAuthResultEntity {
            try container.encode(kakaoAuthToken, forKey: .authToken)
        } else if let appleAuthToken = authToken as? AppleAuthResultEntity {
            try container.encode(appleAuthToken, forKey: .authToken)
        }
    }
}
