//
//  Rx+viewDidLayoutSubviews.swift
//  Utils
//
//  Created by Lee, Joon Woo on 2023/06/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidLayoutSubviews: Observable<Void> {
        let targetSelector = #selector(Base.viewDidLayoutSubviews)
        return sentMessage(targetSelector).map { _ in }
    }
}
