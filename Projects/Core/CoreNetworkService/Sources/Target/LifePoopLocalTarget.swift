//
//  LifePoopLocalTarget.swift
//  CoreNetworkService
//
//  Created by 김상혁 on 2023/09/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

public enum LifePoopLocalTarget {
    case login(provider: String)
    case logout(accessToken: String)
    case updateAccessToken(refreshToken: String)
    case signup(provider: String)
    case fetchUserInfo(accessToken: String)
    case fetchFriendList(accessToken: String)
    case fetchStoolLog(userID: Int)
    case postStoolLog(accessToken: String)
    case sendInvitationCode(code: String, accessToken: String)
    case withdrawAppleAccount(accessToken: String)
    case withdrawKakaoAccount(accessToken: String)
}

extension LifePoopLocalTarget: TargetType {
    public var baseURL: URL? {
        // MARK: 실서버 요청 확인할 경우 아래 url로 사용
        URL(string: "https://api.lifepoo.link")
//        URL(string: "http://localhost:3000")
    }
    
    public var path: String {
        switch self {
        case .updateAccessToken:
            return "/auth/refresh"
        case .signup(let provider):
            return "/auth/\(provider)/register"
        case .login(let provider):
            return "/auth/\(provider)/login"
        case .logout:
            return "/auth/logout"
        case .fetchStoolLog(let userID):
            return "/post/\(userID)"
        case .postStoolLog:
            return "/post"
        case .fetchUserInfo:
            return "/user"
        case .fetchFriendList:
            return "/user/friendship"
        case .sendInvitationCode(let code, _):
            return "/user/friendship/\(code)"
        case .withdrawAppleAccount:
            return "/auth/APPLE/withdraw"
        case .withdrawKakaoAccount:
            return "/auth/KAKAO/withdraw"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchStoolLog, .fetchUserInfo, .fetchFriendList:
            return .get
        case .postStoolLog, .login, .logout, .signup, .updateAccessToken, .sendInvitationCode, .withdrawAppleAccount, .withdrawKakaoAccount:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .postStoolLog(let accessToken),
             .fetchUserInfo(let accessToken),
             .sendInvitationCode(_, let accessToken),
             .fetchFriendList(let accessToken),
             .withdrawAppleAccount(let accessToken),
             .withdrawKakaoAccount(let accessToken),
             .logout(let accessToken)
            :
            return [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        }
    }

    public var cookies: [String: String] {
        switch self {
        case .updateAccessToken(let refreshToken):
            return ["refresh_token": refreshToken]
        default:
            return [:]
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
}
