//
//  Rx+finishLayoutSubviews.swift
//  Utils
//
//  Created by 김상혁 on 2023/10/26.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIView {
    var finishLayoutSubviews: Observable<Void> {
        let targetSelector = #selector(Base.layoutSubviews)
        return sentMessage(targetSelector)
            .map { _ in }
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
    }
}
