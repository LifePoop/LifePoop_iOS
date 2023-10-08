//
//  SignupInfo.swift
//  CoreEntity
//
//  Created by Lee, Joon Woo on 2023/09/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct SignupInput {
    
    public let nickname: String
    public let birthDate: String
    public let gender: GenderType
    public let conditions: Set<AgreementCondition>
    public let oAuthAccessToken: String
    public let provider: LoginType
    
    public init(
        nickname: String,
        birthDate: String,
        gender: GenderType,
        conditions: Set<AgreementCondition>,
        oAuthAccessToken: String,
        provider: LoginType
    ) {
        self.nickname = nickname
        self.birthDate = birthDate
        self.gender = gender
        self.conditions = conditions
        self.oAuthAccessToken = oAuthAccessToken
        self.provider = provider
    }
}
