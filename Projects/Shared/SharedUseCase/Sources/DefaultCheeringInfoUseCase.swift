//
//  DefaultCheeringInfoUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/10/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import Logger
import SharedDIContainer
import Utils

public protocol CheeringInfoUseCase {
    func fetchCheeringInfo(userId: Int, date: String) -> Observable<CheeringInfoEntity>
    func requestCheering(withIdOf id: Int) -> Observable<Bool>
}

public final class DefaultCheeringInfoUseCase: CheeringInfoUseCase {
    
    @Inject(SharedDIContainer.shared) private var cheeringInfoRepository: CheeringInfoRepository
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    
    public init() { }
    
    public func fetchCheeringInfo(userId: Int, date: String) -> Observable<CheeringInfoEntity> {
        return userInfoUseCase
            .userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMap { `self`, accessToken in
                self.cheeringInfoRepository.fetchUserCheeringInfo(
                    accessToken: accessToken,
                    userID: userId,
                    date: date
                )
            }
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    
    public func requestCheering(withIdOf id: Int) -> Observable<Bool> {
        userInfoUseCase.userInfo
            .compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                self.cheeringInfoRepository.requestCheering(
                    accessToken: accessToken,
                    userId: id
                )
            }
            .logErrorIfDetected(category: .network)
            .catchAndReturn(false)
            .asObservable()
    }
}
