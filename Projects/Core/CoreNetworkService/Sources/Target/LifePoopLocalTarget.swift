//
//  LifePoopLocalTarget.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/09/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum LifePoopLocalTarget {
    case fetchStoolLog(userID: Int)
    case postStoolLog(accessToken: String)
}

extension LifePoopLocalTarget: TargetType {
    public var baseURL: URL? {
        switch self {
        case .fetchStoolLog, .postStoolLog:
            return URL(string: "http://localhost:3000")
        }
    }
    
    public var path: String {
        switch self {
        case .fetchStoolLog(let userID):
            return "/post/\(userID)"
        case .postStoolLog:
            return "/post"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchStoolLog:
            return .get
        case .postStoolLog:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .fetchStoolLog:
            return nil
        case .postStoolLog(let accessToken):
            return [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .fetchStoolLog, .postStoolLog:
            return nil
        }
    }
}
