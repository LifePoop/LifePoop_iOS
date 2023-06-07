//
//  ASAuthorizationControllerProxy.swift
//  CoreAuthentication
//
//  Created by 이준우 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import AuthenticationServices

import RxSwift
import RxCocoa

extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

public final class ASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>,
                                                   DelegateProxyType,
                                                   ASAuthorizationControllerDelegate,
                                                   ASAuthorizationControllerPresentationContextProviding {
    
    public static var targetWindow: UIWindow?
    internal lazy var didComplete = PublishSubject<ASAuthorization>()
    
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { parent in
            ASAuthorizationControllerProxy(controller: parent)
        }
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        didComplete.onCompleted()
    }

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let targetWindow = ASAuthorizationController.targetWindow else {
            fatalError("Key Window Not Exists in current context")
        }
        
        return targetWindow
    }
    
    deinit {
        didComplete.onCompleted()
    }
}
