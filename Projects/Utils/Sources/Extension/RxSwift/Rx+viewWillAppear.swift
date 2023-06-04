//
//  Rx+viewWillAppear.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        let targetSelector = #selector(Base.viewWillAppear)
        return sentMessage(targetSelector).map { _ in }
    }
}
