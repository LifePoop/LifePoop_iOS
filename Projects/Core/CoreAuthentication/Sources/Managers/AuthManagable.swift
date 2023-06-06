//
//  AuthManagable.swift
//  CoreAuthentication
//
//  Created by 이준우 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity

public protocol AuthManagable: AnyObject {
        
    static var isAlreadyInitialized: Bool { get }
    
    static func initAuthInfo(rightAfter preparation: (() -> Void)?)
    
    func fetchToken() -> Single<AccessTokenPossessable>
}
