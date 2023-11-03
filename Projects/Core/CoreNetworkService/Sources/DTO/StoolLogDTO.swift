//
//  StoolLogDTO.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/09/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public struct StoolLogDTO: Codable {
    public let id: Int?
    public let isGood: Bool
    public let color: Int
    public let size: Int
    public let shape: Int
    public let date: String
}
