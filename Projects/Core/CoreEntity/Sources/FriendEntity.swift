//
//  FriendEntity.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/02.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public struct FriendEntity {
    public let id: Int
    public let nickname: String
    // TODO: 스토리 API 최종 구현 후 해당 속성 어떻게 할 지 다시 확인
    public var isActivated: Bool
    public let profile: ProfileCharacter
    
    public init(id: Int = 0, nickname: String, isActivated: Bool, profile: ProfileCharacter) {
        self.id = id
        self.nickname = nickname
        self.isActivated = isActivated
        self.profile = profile
    }
    
    // FIXME: API 연동 후 더미데이터 제거해야 함
    public init(nickname: String, isActivated: Bool, profile: ProfileCharacter) {
        self.id = 0
        self.nickname = nickname
        self.isActivated = isActivated
        self.profile = profile
    }
}

extension FriendEntity: Hashable { }

extension FriendEntity {
    public static var dummyData: [FriendEntity] {
        return [
            FriendEntity(nickname: "김유빈", isActivated: true, profile: .init(color: .brown, shape: .soft)),
            FriendEntity(nickname: "이화정", isActivated: false, profile: .init(color: .brown, shape: .good)),
            FriendEntity(nickname: "이준우", isActivated: true, profile: .init(color: .brown, shape: .hard)),
            FriendEntity(nickname: "강시온", isActivated: false, profile: .init(color: .black, shape: .soft)),
            FriendEntity(nickname: "손혜정", isActivated: true, profile: .init(color: .black, shape: .good)),
            FriendEntity(nickname: "김상혁", isActivated: false, profile: .init(color: .black, shape: .hard)),
            FriendEntity(nickname: "강시온가나", isActivated: true, profile: .init(color: .pink, shape: .soft)),
            FriendEntity(nickname: "김상혁다라", isActivated: false, profile: .init(color: .pink, shape: .good)),
            FriendEntity(nickname: "손혜정마바", isActivated: true, profile: .init(color: .pink, shape: .hard)),
            FriendEntity(nickname: "김유빈사아", isActivated: false, profile: .init(color: .green, shape: .soft)),
            FriendEntity(nickname: "이준우자차", isActivated: true, profile: .init(color: .green, shape: .good)),
            FriendEntity(nickname: "이화정카타", isActivated: false, profile: .init(color: .green, shape: .hard)),
            FriendEntity(nickname: "라이푸12", isActivated: false, profile: .init(color: .yellow, shape: .soft)),
            FriendEntity(nickname: "LFPOO", isActivated: true, profile: .init(color: .yellow, shape: .good)),
            FriendEntity(nickname: "12345", isActivated: true, profile: .init(color: .yellow, shape: .hard))
        ]
    }
}
