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
    
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    @Inject(SharedDIContainer.shared) private var userInfoRepository: UserInfoRepository
    
    public init() { }
    
    public var userInfo: Observable<UserInfoEntity?> {
        let userAuthInfo = keyChainRepository
            .getObjectFromKeyChain(
                asTypeOf: UserAuthInfoEntity.self,
                forKey: .userAuthInfo,
                handleExceptionWhenValueNotFound: false
            )
            .logErrorIfDetected(category: .authentication)
            .catchAndReturn(nil)
            .map { $0 }
            .asObservable()
        
        let userId: Observable<Int> = userDefaultsRepository
            .getValue(for: .userId)
            .map { $0 ?? -1 }
            .asObservable()
        
        let nickname: Observable<String> = userDefaultsRepository
            .getValue(for: .userNickname)
            .map { $0 ?? "" }
            .asObservable()
        
        let birthDate: Observable<String> = userDefaultsRepository
            .getValue(for: .birthDate)
            .map { $0 ?? "" }
            .asObservable()
        
        let genderType: Observable<GenderType> = userDefaultsRepository
            .getValue(for: .genderType)
            .map { $0 ?? .other }
            .asObservable()

        let invitationCode: Observable<String> = userDefaultsRepository
            .getValue(for: .invitationCode)
            .map { $0 ?? "" }
            .asObservable()
        
        let profileCharacter: Observable<ProfileCharacter?> = userDefaultsRepository
            .getValue(for: .profileCharacter)
            .map { $0 }
            .asObservable()
        
        return Observable.combineLatest(
            userAuthInfo,
            userId,
            nickname,
            birthDate,
            genderType,
            invitationCode,
            profileCharacter
        )
        .map { authInfo, userId, nickname, birthDate, genderType, invitationCode, profileCharacter in
            guard let authInfo = authInfo else { return nil }
            guard let profileCharacter = profileCharacter else { return nil }
            
            return UserInfoEntity(
                userId: userId,
                nickname: nickname,
                birthDate: birthDate,
                genderType: genderType,
                profileCharacter: profileCharacter,
                invitationCode: invitationCode,
                authInfo: authInfo
            )
        }
        .asObservable()
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
            .concatMap { `self`, updatedUserInfo in
                self.saveUserInfo(updatedUserInfo)
                    .andThen(Observable.just(true))
                    .catchAndReturn(false)
            }
            .catch { [weak self] _ in
                guard let `self` = self else {
                    return Observable.just(false)
                }

                NotificationCenter.default.post(name: .resetLogin, object: nil)
                
                return self.removeUserInfo().andThen(Observable.just(false))
            }
    }
    
    public func fetchUserInfo(with authInfo: UserAuthInfoEntity) -> Observable<Bool> {
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
    
    public func requestLogout() -> Observable<Bool> {
        userInfo.compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                self.userInfoRepository.requestLogout(accessToken: accessToken)
                    .catchAndReturn(false)
            }
            .withUnretained(self)
            .concatMap { `self`, isSuccess in
                if isSuccess {
                    return self.removeUserInfo().andThen(Observable.just(true))
                } else {
                    return Observable.just(false)
                }
            }
            .asObservable()
    }
    
    public func requestAccountWithdrawl(for loginType: LoginType) -> Observable<Bool> {
        
        var observable: Observable<Bool>
        switch loginType {
        case .apple:
            observable = requestAppleAccountWithdrawl()
        case .kakao:
            observable = requestKakaoAccountWithdrawl()
        }
        
        return observable
            .withUnretained(self)
            .concatMap { `self`, isSuccess in
                if isSuccess {
                    return self.removeUserInfo().andThen(Observable.just(true))
                } else {
                    return Observable.just(false)
                }
            }
    }
}

private extension DefaultUserInfoUseCase {
    
    func requestAppleAccountWithdrawl() -> Observable<Bool> {
        userInfoRepository.fetchAppleAuthorizationCode()
            .asObservable()
            .withLatestFrom(userInfo) {
                (authorizationCode: $0, accessToken: $1?.authInfo.accessToken)
            }
            .withUnretained(self)
            .flatMapLatest {
                let `self` = $0.0
                let authorizationCode = $0.1.authorizationCode
                let accessToken = $0.1.accessToken ?? "" // accessToken nil 처리 필요
                // TODO: 추후 예외처리 구체적으로
                return self.userInfoRepository.requestAppleWithdrawl(authorizationCode: authorizationCode, accessToken: accessToken)
            }
            .asObservable()
            .catchAndReturn(false)
    }

    func requestKakaoAccountWithdrawl() -> Observable<Bool> {
        userInfo.compactMap { $0?.authInfo.accessToken }
            .withUnretained(self)
            .flatMapLatest { `self`, accessToken in
                // TODO: 추후 예외처리 구체적으로
                self.userInfoRepository.requestKakaoWithdrawl(accessToken: accessToken)
            }
            .asObservable()
            .catchAndReturn(false)
    }

    func saveUserInfo(_ userInfo: UserInfoEntity) -> Completable {
        
        Logger.log(
            message: """
            업데이트된 사용자 정보 KeyChain, UserDefaults에 저장
            nickname: \(userInfo.nickname), loginType: \(userInfo.authInfo.loginType?.description ?? "")
            """,
            category: .authentication,
            type: .debug
        )
        
        return keyChainRepository
            .saveObjectToKeyChain(userInfo.authInfo, forKey: .userAuthInfo)
            .concat(userDefaultsRepository.updateValue(for: .userNickname, with: userInfo.nickname))
            .concat(userDefaultsRepository.updateValue(for: .userLoginType, with: userInfo.authInfo.loginType))
            .concat(userDefaultsRepository.updateValue(for: .profileCharacter, with: userInfo.profileCharacter))
            .concat(userDefaultsRepository.updateValue(for: .userId, with: userInfo.userId))
            .concat(userDefaultsRepository.updateValue(for: .birthDate, with: userInfo.birthDate))
            .concat(userDefaultsRepository.updateValue(for: .invitationCode, with: userInfo.invitationCode))
            .logErrorIfDetected(category: .authentication)
    }
    
    func removeUserInfo() -> Completable {
        
        Logger.log(
            message: """
            기존 사용자정보 제거
            """,
            category: .authentication,
            type: .debug
        )
        return keyChainRepository
            .removeObjectFromKeyChain(forKey: .userAuthInfo)
            .concat(userDefaultsRepository.removeValue(for: .userNickname))
            .concat(userDefaultsRepository.removeValue(for: .userLoginType))
            .concat(userDefaultsRepository.removeValue(for: .profileCharacter))
            .concat(userDefaultsRepository.removeValue(for: .invitationCode))
            .concat(userDefaultsRepository.removeValue(for: .birthDate))
            .concat(userDefaultsRepository.removeValue(for: .genderType))
    }
}
