//
//  LoginType.swift
//  CoreEntity
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum LoginType: String, Codable {
    case apple
    case kakao
    
    public var description: String {
        return rawValue.uppercased()
    }
}
