//
//  LifePoopTarget.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/04/27.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public enum LifePoopTarget {
    // Login
    case fetchTempCode
    case fetchAccessToken(clientID: String, clientSecret: String, tempCode: String)
}

extension LifePoopTarget: TargetType {
    public var baseURL: URL? {
        switch self {
        case .fetchTempCode, .fetchAccessToken:
            return URL(string: "https://github.com")
        }
    }
    
    public var path: String {
        switch self {
        case .fetchTempCode:
            return "/login/oauth/authorize"
        case .fetchAccessToken:
            return "/login/oauth/access_token"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchTempCode:
            return .get
        case .fetchAccessToken:
            return .post
        }
    }
    
    public var cookies: [String: String] {
        switch self {
        default:
            return [:]
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .fetchTempCode:
            return nil
        case .fetchAccessToken:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .fetchTempCode:
            return ["scope": "repo, user"]
        case .fetchAccessToken(let clientID, let clientSecret, let tempCode):
            return ["scope": "repo, user",
                    "client_id": clientID,
                    "client_secret": clientSecret,
                    "code": tempCode]
        }
    }
}
