//
//  DefaultBundleResourceRepository.swift
//  SharedRepository
//
//  Created by 김상혁 on 2023/06/03.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import SharedUseCase
import Utils

public final class DefaultBundleResourceRepository: BundleResourceRepository {
    
    public init() { }
    
    public func determineAppVersion() -> Single<String> {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return .error(BundleError.invalidInfoDictionaryKey)
        }
        return .just(appVersion)
    }
    
    public func readText(from file: TextFile) -> Single<String> {
        guard let utilsBundle = Bundle.utils else {
            return .error(BundleError.invalidBundleIdentifier)
        }
        
        guard let path = utilsBundle.path(forResource: file.name, ofType: "txt") else {
            return .error(BundleError.invalidResourcePath)
        }
        
        guard let text = try? String(contentsOfFile: path, encoding: .utf8) else {
            return .error(BundleError.encodingError)
        }
        
        return .just(text)
    }
}
