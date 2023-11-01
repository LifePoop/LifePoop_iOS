//
//  CheeringInfoDTO.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct CheeringInfoDTO: Decodable {
    let count: Int
    let thumbs: [UserProfileDTO]
}
