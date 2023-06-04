//
//  AccessTokenPossessable.swift
//  CoreEntity
//
//  Created by 이준우 on 2023/05/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public protocol AccessTokenPossessable: Codable {
    
    var accessToken: String { get }
}
