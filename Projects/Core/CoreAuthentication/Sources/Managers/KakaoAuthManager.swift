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
        // FIXME: 추후 키값 코드에서 감춰놔야 함
        KakaoSDK.initSDK(appKey: "f7f327d46b7184823676acc9d0a2035c")
        
        _isAlreadyInitialized = true
    }
    
    public static func handleLoginUrl(_ url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
        
    public func fetchAccessToken() -> Single<String> {
        return Single.create { observer in
            guard KakaoAuthManager.isAlreadyInitialized else {
                observer(.failure(AuthenticationError.authInfoNotInitialized))
                return Disposables.create { }
            }

            let isKakaoTalkLoginAvailable = UserApi.isKakaoTalkLoginAvailable()

            if isKakaoTalkLoginAvailable {
                UserApi.shared.loginWithKakaoTalk { token, error in
                    observer(handleResult(token, error))
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { token, error in
                    observer(handleResult(token, error))
                }
            }
            
            return Disposables.create()
        }
        
        func handleResult(_ token: OAuthToken?, _ error: Error?) -> Result<String, Error> {
            if let error = error {
                return .failure(handleError(error))
            }
            
            guard let token = token else {
                return .failure(AuthenticationError.authTokenNil)
            }
            
            return .success(token.accessToken)
        }
        
        func handleError(_ error: Error) -> Error {
            guard let error = error as? SdkError  else {
                return error
            }
            
            switch error {
            case .ClientFailed(let reason, _):
                switch reason {
                case .Cancelled:
                    return AuthenticationError.kakaoLoginCancelledByUser
                default:
                    return error
                }
            default:
                return error
            }
        }
    }
}
