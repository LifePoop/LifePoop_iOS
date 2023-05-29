//
//  Rx+ASAuthorizationAppleIDProvider.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/05/25.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import AuthenticationServices
import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: ASAuthorizationAppleIDProvider {

    private var keyWindow: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }

    func login(scope: [ASAuthorization.Scope]) -> Observable<ASAuthorization> {
        guard let window = keyWindow else {
            fatalError("Key Window Not Exists in current context")
        }
        
        let authRequest = base.createRequest()
        authRequest.requestedScopes = scope
        
        let authController = ASAuthorizationController(authorizationRequests: [authRequest])
        
        let delegateProxy = ASAuthorizationControllerProxy.proxy(for: authController)
        delegateProxy.targetWindow = window
        
        authController.presentationContextProvider = delegateProxy
        authController.performRequests()
        
        return delegateProxy.didComplete
    }
}

extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

class ASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>,
                                            DelegateProxyType,
                                            ASAuthorizationControllerDelegate,
                                            ASAuthorizationControllerPresentationContextProviding {
    
    var targetWindow: UIWindow = UIWindow()
    internal lazy var didComplete = PublishSubject<ASAuthorization>()
    
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { parent in
            ASAuthorizationControllerProxy(controller: parent)
        }
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        didComplete.onCompleted()
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        targetWindow
    }
    
    deinit {
        didComplete.onCompleted()
    }
}
