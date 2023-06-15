//
//  Rx+viewDidAppear.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidAppear: Observable<Void> {
        let targetSelector = #selector(Base.viewDidAppear)
        return sentMessage(targetSelector).map { _ in }
    }
}
