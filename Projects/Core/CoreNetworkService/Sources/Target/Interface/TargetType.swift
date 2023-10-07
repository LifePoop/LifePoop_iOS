//
//  TargetType.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol TargetType {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var cookies: [String: String] { get }
    var parameters: [String: Any]? { get }
}
