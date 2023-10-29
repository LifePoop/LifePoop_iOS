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
}

public final class DefaultCheeringInfoUseCase: CheeringInfoUseCase {
    
    @Inject(SharedDIContainer.shared) private var cheeringInfoRepository: CheeringInfoRepository
    // FIXME: 의존성 주입 방식으로 변경
    private let tempUserInfoUseCase: UserInfoUseCase = TempUserInfoUseCase()
    
    public init() { }
    
    public func fetchCheeringInfo(userId: Int, date: String) -> Observable<CheeringInfoEntity> {
        return tempUserInfoUseCase
            .fetchUserInfo()
            .map { $0.authInfo.accessToken }
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
}
