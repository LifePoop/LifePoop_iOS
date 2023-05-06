//
//  Rx+viewDidLoad.swift
//  Utils
//
//  Created by 김상혁 on 2023/05/05.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        let targetSelector = #selector(Base.viewDidLoad)
        return sentMessage(targetSelector).map { _ in }
    }
}
