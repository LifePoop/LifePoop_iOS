//
//  UserAuthInfoEntity.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct OAuthTokenInfo: Codable {

    public let loginType: LoginType?
    public let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken
        case loginType
    }

    public init(loginType: LoginType, accessToken: String) {
        self.loginType = loginType
        self.accessToken = accessToken
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawLoginType = try container.decode(String.self, forKey: .loginType)
        self.loginType = LoginType(rawValue: rawLoginType) ?? .none
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(loginType?.rawValue ?? "", forKey: .loginType)
        try container.encode(accessToken, forKey: .accessToken)
    }
}
