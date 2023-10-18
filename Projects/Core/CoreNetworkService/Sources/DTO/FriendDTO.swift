//
//  FriendDTO.swift
//  CoreNetworkService
//
//  Created by Lee, Joon Woo on 2023/10/15.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct FriendDTO: Codable {
    
    public let id: Int
    public let nickname: String
    public let birth: String
    public let sex: String
    public let characterColor: Int
    public let characterShape: Int
}

