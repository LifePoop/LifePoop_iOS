//
//  BundleResourceUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import Utils

public protocol BundleResourceUseCase {
    func determineAppVersion() -> Observable<String>
    func readText(from file: TextFile) -> Observable<String>
}
