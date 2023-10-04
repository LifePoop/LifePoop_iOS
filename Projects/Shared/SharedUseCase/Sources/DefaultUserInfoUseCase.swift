//
//  DefaultUserInfoUseCase.swift
//  SharedUseCase
//
//  Created by Lee, Joon Woo on 2023/10/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity
import Logger
import RxSwift
import SharedDIContainer
import Utils

public final class DefaultUserInfoUseCase: UserInfoUseCase {
    
    enum UserInfoError: Error {
        case refreshingTokenFailed
        case refreshingUserInfoFailed
    }
    
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    @Inject(SharedDIContainer.shared) private var userInfoRepository: UserInfoRepository
    
    public init() { }
    
    public var userInfo: Observable<UserInfoEntity?> {
        keyChainRepository
            .getObjectFromKeyChain(
                asTypeOf: UserInfoEntity.self,
                forKey: .userAuthInfo,
                handleExceptionWhenValueNotFound: false
            )
            .logErrorIfDetected(category: .authentication)
            .catchAndReturn(nil)
            .asObservable()
            .do(onNext: { userInfo in
                let nickname = userInfo?.nickname ?? "nil"
                let loginType = userInfo?.authInfo.loginType?.rawValue ?? "nil"
                Logger.log(
                    message: "KeyChain 사용자 정보 확인: \(nickname), 로그인 유형: \(loginType)",
                    category: .authentication,
                    type: .debug
                )
            })
    }
    
    public func refreshAuthInfo(with authInfo: UserAuthInfoEntity) -> Observable<Bool> {
        userInfoRepository.requestRefreshingUserAuthInfo(with: authInfo)
            .do(onSuccess: { updatedAuthInfo in
                Logger.log(
                    message: "서버로부터 인증정보 업데이트 성공: \(updatedAuthInfo != nil)",
                    category: .authentication,
                    type: .debug
                )
            }, onError: { error in
                Logger.log(
                    message: "서버로부터 인증정보 업데이트 실패 : \(error)",
                    category: .authentication,
                    type: .error
                )
            })
            .asObservable()
            .withLatestFrom(userInfo) { (updatedAuthInfo: $0, originalUserInfo: $1) }
            .map { updatedAuthInfo, originalUserInfo in
                guard let updatedAuthInfo = updatedAuthInfo,
                      let originalUserInfo = originalUserInfo else {
                    
                    throw UserInfoError.refreshingTokenFailed
                }
                
                return UserInfoEntity(
                    userId: originalUserInfo.userId,
                    nickname: originalUserInfo.nickname,
                    birthDate: originalUserInfo.birthDate,
                    genderType: originalUserInfo.genderType,
                    profileCharacter: originalUserInfo.profileCharacter,
                    invitationCode: originalUserInfo.invitationCode,
                    authInfo: updatedAuthInfo
                )
            }
            .withUnretained(self)
            .flatMap { `self`, updatedUserInfo in
                self.saveUserInfo(updatedUserInfo)
                    .andThen(Observable.just(true))
                    .catchAndReturn(false)
            }
            .catch { [weak self] _ in
                guard let `self` = self else {
                    return Observable.just(false)
                }
                
                return self.clearUserInfoIfNeeded()
            }
    }
    
    public func refreshUserInfo(with authInfo: UserAuthInfoEntity) -> Observable<Bool> {
        userInfoRepository.fetchUserInfo(with: authInfo)
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { `self`, userInfo in
                guard let userInfo = userInfo else {
                    return Observable<Bool>.error(UserInfoError.refreshingUserInfoFailed)
                }
                
                return self.saveUserInfo(userInfo)
                    .andThen(Observable.just(true))
                    .catch { Observable.error($0) }
            }
    }
}

private extension DefaultUserInfoUseCase {
    
    func clearUserInfoIfNeeded() -> Observable<Bool> {
        userInfo
            .withUnretained(self)
            .flatMap { `self`, userInfo in
                self.removeUserInfo(userInfo)
                    .andThen(Observable.just(false))
            }
    }
    
    func saveUserInfo(_ userInfo: UserInfoEntity) -> Completable {
        
        Logger.log(
            message: """
            업데이트된 사용자 정보 KeyChain에 저장
            nickname: \(userInfo.nickname), loginType: \(userInfo.authInfo.loginType?.description ?? "")
            """,
            category: .authentication,
            type: .debug
        )
        
        return keyChainRepository
            .saveObjectToKeyChain(userInfo, forKey: .userAuthInfo)
            .concat(userDefaultsRepository.updateValue(for: .userNickname, with: userInfo.nickname))
            .concat(userDefaultsRepository.updateValue(for: .userLoginType, with: userInfo.authInfo.loginType))
            .concat(userDefaultsRepository.updateValue(for: .profileCharacter, with: userInfo.profileCharacter))
            .logErrorIfDetected(category: .authentication)
    }
    
    func removeUserInfo(_ userInfo: UserInfoEntity?) -> Completable {
        guard let userInfo = userInfo else {
            return .empty()
        }
        
        Logger.log(
            message: """
            기존 사용자정보 제거
            nickname: \(userInfo.nickname)
            loginType: \(userInfo.authInfo.loginType?.description ?? "")
            """,
            category: .authentication,
            type: .debug
        )
        
        return keyChainRepository
            .removeObjectFromKeyChain(forKey: .userAuthInfo)
            .concat(userDefaultsRepository.removeValue(for: .userNickname))
            .concat(userDefaultsRepository.removeValue(for: .userLoginType))
            .concat(userDefaultsRepository.removeValue(for: .profileCharacter))
    }
}
