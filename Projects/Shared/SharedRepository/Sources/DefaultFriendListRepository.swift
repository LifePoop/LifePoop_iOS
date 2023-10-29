//
//  DefaultFriendListRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/10/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreDIContainer
import CoreEntity
import CoreNetworkService
import SharedUseCase
import Utils

public final class DefaultFriendListRepository: FriendListRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    
    public init() { }
    
    // TODO: dummy -> 실제 API 연결
    public func fetchFriendList() -> Single<[FriendEntity]> {
        return .just(FriendEntity.dummyData)
    }
}
