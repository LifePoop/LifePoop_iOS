//
//  Rx+ASAuthorizationAppleIDProvider.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/05/25.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import AuthenticationServices

import RxSwift

public extension Reactive where Base: ASAuthorizationAppleIDProvider {

    func login(scope: [ASAuthorization.Scope]) -> Observable<ASAuthorization> {
        
        let authRequest = base.createRequest()
        authRequest.requestedScopes = scope
        
        let authController = ASAuthorizationController(authorizationRequests: [authRequest])
        
        let delegateProxy = ASAuthorizationControllerProxy.proxy(for: authController)
        authController.presentationContextProvider = delegateProxy
        authController.performRequests()
        
        return delegateProxy.didComplete
    }
}
