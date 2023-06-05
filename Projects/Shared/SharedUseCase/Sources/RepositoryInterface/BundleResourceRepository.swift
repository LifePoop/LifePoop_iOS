//
//  BundleResourceRepository.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import Utils

public protocol BundleResourceRepository {
    func determineAppVersion() -> Single<String>
    func readText(from file: TextFile) -> Single<String>
}
