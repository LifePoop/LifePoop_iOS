//
//  Rx+viewDidDisappear.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidDisappear: Observable<Void> {
        let targetSelector = #selector(Base.viewDidDisappear)
        return sentMessage(targetSelector).map { _ in }
    }
}
