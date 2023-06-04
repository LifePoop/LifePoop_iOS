//
//  KakaoAuthManager.swift
//  Auth
//
//  Created by 이준우 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import CoreEntity

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxSwift

public final class KakaoAuthManager: AuthManagable {

    private static var _isAlreadyInitialized = false
    public static var isAlreadyInitialized: Bool {
        _isAlreadyInitialized
    }
    public init() { }
    
    public static func initAuthInfo(rightAfter preparation: (() -> Void)?) {
        guard !isAlreadyInitialized else { return }
        
        preparation?()

        let serialQueue = DispatchQueue(label: "serial-queue-kakao-auth")
        serialQueue.sync {
            // FIXME: 추후 키값 코드에서 감춰놔야 함
            KakaoSDK.initSDK(appKey: "f7f327d46b7184823676acc9d0a2035c")
            
            _isAlreadyInitialized = true
        }
    }
    
    public static func handleLoginUrl(_ url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
        
    public func fetchToken() -> Single<AccessTokenPossessable> {
        Single.create { observer in
            guard KakaoAuthManager.isAlreadyInitialized else {
                observer(.failure(AuthenticationError.authInfoNotInitialized))
                return Disposables.create { }
            }
            
            guard UserApi.isKakaoTalkLoginAvailable() else {
                observer(.failure(AuthenticationError.kakaoTalkLoginNotAvailable))
                return Disposables.create { }
            }
            
            UserApi.shared.loginWithKakaoTalk(completion: { token, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let token = token else {
                    observer(.failure(AuthenticationError.authTokenNil))
                    return
                }
                
                let authResultEntity = KakaoAuthResultEntity(
                    accessToken: token.accessToken,
                    refreshToken: token.refreshToken
                )
                
                observer(.success(authResultEntity))
            })
            
            return Disposables.create()
        }
    }
}
