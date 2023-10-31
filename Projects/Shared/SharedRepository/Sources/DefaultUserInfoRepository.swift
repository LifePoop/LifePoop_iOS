//
//  DefaultUserInfoRepository.swift
//  SharedRepository
//
//  Created by Lee, Joon Woo on 2023/10/01.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreAuthentication
import CoreDIContainer
import CoreEntity
import CoreNetworkService
import Logger
import RxSwift
import SharedUseCase
import Utils

public final class DefaultUserInfoRepository: UserInfoRepository {
    
    @Inject(CoreDIContainer.shared) private var urlSessionEndpointService: EndpointService
    
    public init() { }
    
    /** Refresh Token으로 서버로부터 Access Token, Refresh Token 업데이트 */
    public func requestRefreshingUserAuthInfo(
        with authInfo: UserAuthInfoEntity
    ) -> Single<UserAuthInfoEntity?> {
        urlSessionEndpointService
            .fetchNetworkResult(
                endpoint: LifePoopLocalTarget.updateAccessToken(
                    refreshToken: authInfo.refreshToken
                )
            )
            .logErrorIfDetected(category: .network)
            .asObservable()
            .withUnretained(self)
            .map { `self`, networkResult -> UserAuthInfoEntity? in
                let statusCode = networkResult.statusCode
                let responseData = String(data: networkResult.data ?? Data(), encoding: .utf8) ?? ""
                let url = networkResult.response.url?.absoluteString ?? ""
                guard statusCode >= 200 && statusCode < 300 else {
                    
                    Logger.log(
                        message: "토큰 업데이트 요청 에러:\n\(url)\n\(responseData)",
                        category: .network,
                        type: .error
                    )
                    
                    throw NetworkError.invalidStatusCode(code: statusCode)
                }
                
                var accessToken: String?
                var refreshToken: String?
                
                // MARK: AccessToken 추출
                if let bodyData = networkResult.data {
                    let body = try JSONDecoder().decode([String: String].self, from: bodyData)
                    accessToken = body["accessToken"]
                }
                
                // MARK: RefreshToken 추출
                if let cookies = networkResult.cookies {
                    refreshToken = cookies["refresh_token"]
                }
                
                return self.createUpdatedUserAuthInfo(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    loginType: authInfo.loginType
                )
            }
            .asSingle()
    }
    
    /** 전달된 refresh tokenm, access token으로 서버로부터 해당되는 사용자 정보 요청 */
    public func fetchUserInfo(with authInfo: UserAuthInfoEntity) -> Single<UserInfoEntity?> {
        urlSessionEndpointService
            .fetchData(endpoint: LifePoopLocalTarget.fetchUserInfo(accessToken: authInfo.accessToken))
            .decodeMap(UserInfoDTO.self)
            .map { dto in
                guard let genderType = GenderType(stringValue: dto.sex),
                      let profileColor = StoolColor(rawValue: dto.characterColor - 1),
                      let profileShape = StoolShape(rawValue: dto.characterShape - 1) else {
                    
                    throw NetworkError.dataMappingError
                }
                // TODO: Mapper 사용하도록 수정
                return UserInfoEntity(
                    userId: dto.id,
                    nickname: dto.nickname,
                    birthDate: dto.birth,
                    genderType: genderType,
                    profileCharacter: ProfileCharacter(color: profileColor, shape: profileShape),
                    invitationCode: dto.inviteCode,
                    authInfo: authInfo
                )
            }
            .logErrorIfDetected(category: .network, type: .error)
    }

    /** 로그아웃 요청 */
    public func requestLogout(accessToken: String) -> Single<Bool> {
        urlSessionEndpointService
            .fetchStatusCode(
                endpoint: LifePoopLocalTarget.logout(
                    accessToken: accessToken
                )
            )
            .map { statusCode in
                switch statusCode {
                case 204:
                    return true
                case 444:
                    throw NetworkError.invalidAccessToken
                default:
                    throw NetworkError.invalidStatusCode(code: statusCode)
                }
            }
    }

    
    public func fetchAppleAuthorizationCode() -> Single<String> {
        let appleAuthManager = AppleAuthManager()
        return appleAuthManager.fetchAuthorizationCode()
    }
    
    /** Apple  계정 탈퇴 요청 */
    public func requestAppleWithdrawl(authorizationCode: String, accessToken: String) -> Single<Bool> {
        self.urlSessionEndpointService
            .fetchStatusCode(
                endpoint: LifePoopLocalTarget.withdrawAppleAccount(
                    accessToken: accessToken
                ),
                // TODO: 추후 인코딩 가능한 객체로 변경
                with: [
                    "authorizationCode": authorizationCode
                ]
            )
            .asObservable()
            .withUnretained(self)
            .map { `self`, statusCode in
                switch statusCode {
                case 204:
                    return true
                case 444:
                    throw NetworkError.invalidAccessToken
                default:
                    throw NetworkError.invalidStatusCode(code: statusCode)
                }
            }
            .asSingle()
    }

    /** Kakao  계정 탈퇴 요청 */
    public func requestKakaoWithdrawl(accessToken: String) -> Single<Bool> {
        self.urlSessionEndpointService
            .fetchStatusCode(
                endpoint: LifePoopLocalTarget.withdrawKakaoAccount(
                    accessToken: accessToken
                )
            )
            .asObservable()
            .withUnretained(self)
            .map { `self`, statusCode in
                switch statusCode {
                case 204:
                    return true
                case 444:
                    throw NetworkError.invalidAccessToken
                default:
                    throw NetworkError.invalidStatusCode(code: statusCode)
                }
            }
            .asSingle()
    }
}

private extension DefaultUserInfoRepository {
    
    func createUpdatedUserAuthInfo(
        accessToken: String?,
        refreshToken: String?,
        loginType: LoginType?
    ) -> UserAuthInfoEntity? {
        guard let accessToken = accessToken,
              let refreshToken = refreshToken,
              let loginType = loginType else { return nil }
        
        return UserAuthInfoEntity(
            loginType: loginType,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
