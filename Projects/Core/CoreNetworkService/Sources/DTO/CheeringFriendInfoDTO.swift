//
//  CheeringFriendInfoDTO.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct CheeringFriendInfoDTO: Decodable {
    let nickname: String
    let characterColor, characterShape: Int
}
