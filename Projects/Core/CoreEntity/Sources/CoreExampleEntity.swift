//
//  CoreExampleEntity.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/26.
//

import Foundation

public struct CoreExampleEntity {
    public let name: String
    public let age: Int
    
    public init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// 임시로 인증토큰 확인하기 위한 구조체
public struct KakaoAuthResult: Codable {
    let accessToken: String
    let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
