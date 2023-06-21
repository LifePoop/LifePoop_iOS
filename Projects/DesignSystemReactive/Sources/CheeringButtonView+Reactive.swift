//
//  CheeringButtonView+Reactive.swift
//  DesignSystemReactive
//
//  Created by 김상혁 on 2023/06/18.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import DesignSystem

public extension Reactive where Base == CheeringButtonView {
    var tap: ControlEvent<Void> {
        return base.containerButton.rx.tap
    }
}

public extension Reactive where Base == CheeringButtonView {
    var titleText: Binder<String?> {
        return base.titleLabel.rx.text
    }
}
