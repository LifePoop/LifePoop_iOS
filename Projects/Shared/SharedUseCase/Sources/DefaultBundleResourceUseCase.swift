//
//  DefaultBundleResourceUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/06/03.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import Logger
import SharedDIContainer
import Utils

public final class DefaultBundleResourceUseCase: BundleResourceUseCase {
    
    @Inject(SharedDIContainer.shared) private var bundleResourceRepository: BundleResourceRepository
    
    public init() { }
    
    public func determineAppVersion() -> Observable<String> {
        return bundleResourceRepository
            .determineAppVersion()
            .logErrorIfDetected(category: .bundle)
            .asObservable()
    }
    
    public func readText(from file: TextFile) -> Observable<String> {
        return bundleResourceRepository
            .readText(from: file)
            .logErrorIfDetected(category: .bundle)
            .asObservable()
    }
}
