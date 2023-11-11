//
//  UserAuthInfoEntity.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/09/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct UserAuthInfoEntity: Codable, CustomStringConvertible {
    
    public let loginType: LoginType?
    public let accessToken: String
    public let refreshToken: String
    
    public var description: String {
        """
        loginType: \(loginType)
        accessTokenExists: \(!accessToken.isEmpty)
        refreshTokenExists: \(!refreshToken.isEmpty)
        """
    }
    
    enum CodingKeys: String, CodingKey {
        case loginType
        case accessToken
        case refreshToken
    }
    
    public init(loginType: LoginType, accessToken: String, refreshToken: String) {
        self.loginType = loginType
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawLoginType = try container.decode(String.self, forKey: .loginType)
        self.loginType = LoginType(rawValue: rawLoginType) ?? .none
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(loginType?.rawValue ?? "", forKey: .loginType)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(refreshToken, forKey: .refreshToken)
    }
}
