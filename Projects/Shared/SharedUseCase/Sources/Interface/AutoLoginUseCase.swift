//
//  AutoLoginUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

public protocol AutoLoginUseCase {
    var isAutoLoginActivated: Observable<Bool?> { get }
    func updateIsAutoLoginActivated(to newValue: Bool) -> Completable
}
