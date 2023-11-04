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
    case login(provider: String)
    case logout(accessToken: String)
    case updateAccessToken(refreshToken: String)
    case signup(provider: String)
    case fetchUserInfo(accessToken: String)
    case fetchFriendList(accessToken: String)
    case fetchStoryFeed(accessToken: String)
    case fetchStoolLog(accessToken: String, userID: Int)
    case fetchStoolLogAtDate(accessToken: String, userID: Int, date: String)
    case postStoolLog(accessToken: String)
    case fetchFriendsWithStories(accessToken: String)
    case fetchCheeringInfo(accessToken: String, userID: Int, date: String)
    case cheerFriend(accessToken: String, userID: Int)
    case sendInvitationCode(code: String, accessToken: String)
    case withdrawAppleAccount(accessToken: String)
    case withdrawKakaoAccount(accessToken: String)
    case editProfileInfo(accessToken: String)
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
        case .cheerFriend(_, let userID):
            return "/user/cheer/\(userID)"
        case .fetchUserInfo:
            return "/user"
        case .fetchFriendList:
            return "/user/friendship"
        case .fetchStoryFeed:
            return "/story"
        case .sendInvitationCode(let code, _):
            return "/user/friendship/\(code)"
        case .withdrawAppleAccount:
            return "/auth/APPLE/withdraw"
        case .withdrawKakaoAccount:
            return "/auth/KAKAO/withdraw"
        case .editProfileInfo:
            return "/user"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchStoolLog,
                .fetchStoolLogAtDate,
                .fetchFriendsWithStories,
                .fetchCheeringInfo,
                .fetchUserInfo,
                .fetchFriendList,
                .fetchStoryFeed:
            return .get
        case .postStoolLog,
                .login,
                .logout,
                .signup,
                .updateAccessToken,
                .sendInvitationCode,
                .withdrawAppleAccount,
                .withdrawKakaoAccount,
                .cheerFriend:
            return .post
        case .editProfileInfo:
            return .put
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .fetchStoolLog(let accessToken, _),
             .fetchStoolLogAtDate(let accessToken, _, _),
             .postStoolLog(let accessToken),
             .fetchFriendsWithStories(let accessToken),
             .fetchCheeringInfo(let accessToken, _, _),
             .cheerFriend(let accessToken, _),
             .fetchUserInfo(let accessToken),
             .sendInvitationCode(_, let accessToken),
             .fetchFriendList(let accessToken),
             .fetchStoryFeed(let accessToken),
             .withdrawAppleAccount(let accessToken),
             .withdrawKakaoAccount(let accessToken),
             .logout(let accessToken),
             .editProfileInfo(let accessToken):
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
