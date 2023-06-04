//
//  KakaoAuthResult.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/05/25.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

// 임시로 인증토큰 확인하기 위한 구조체
public struct KakaoAuthResultEntity: Codable, AccessTokenPossessable {

    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
