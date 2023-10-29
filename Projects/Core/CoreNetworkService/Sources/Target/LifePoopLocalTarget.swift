//
//  LifePoopLocalTarget.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/09/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

// FIXME: LifePoopTarget에 구현하는 것으로 수정

public enum LifePoopLocalTarget {
    case login(accessToken: String, provider: String)
    case fetchStoolLog(accessToken: String, userID: Int)
    case fetchStoolLogAtDate(accessToken: String, userID: Int, date: String)
    case postStoolLog(accessToken: String)
    case fetchFriendsWithStories(accessToken: String)
    case fetchCheeringInfo(accessToken: String, userID: Int, date: String)
}

extension LifePoopLocalTarget: TargetType {
    public var baseURL: URL? {
//        return URL(string: "http://localhost:3000")
        return URL(string: "https://api.lifepoo.link")
    }
    
    public var path: String {
        switch self {
        case .login:
            return "/auth/*/login"
        case .fetchStoolLog(_, let userID):
            return "/post/\(userID)"
        case .fetchStoolLogAtDate(_, let userID, let date):
            return "/post/\(userID)/\(date)"
        case .postStoolLog:
            return "/post"
        case .fetchFriendsWithStories:
            return "/story"
        case .fetchCheeringInfo(_, let userID, let date):
            return "/user/\(userID)/cheer/\(date)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .fetchStoolLog,
                .fetchStoolLogAtDate,
                .fetchFriendsWithStories,
                .fetchCheeringInfo:
            return .get
        case .postStoolLog:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .login:
            return nil
        case .fetchStoolLog(let accessToken, _),
                .fetchStoolLogAtDate(let accessToken, _, _),
                .postStoolLog(let accessToken),
                .fetchFriendsWithStories(let accessToken),
                .fetchCheeringInfo(let accessToken, _, _):
            return [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .login(let accessToken, let provider):
            return [
                "accessToken": accessToken,
                "provider": provider
            ]
        case .fetchStoolLog,
                .fetchStoolLogAtDate,
                .postStoolLog,
                .fetchFriendsWithStories,
                .fetchCheeringInfo:
            return nil
        }
    }
}
