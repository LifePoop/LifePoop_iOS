//
//  SegmentedProgressView+Reactive.swift
//  DesignSystemReactive
//
//  Created by Lee, Joon Woo on 2023/06/28.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import DesignSystem

public extension Reactive where Base == SegmentedProgressView {
    
    var currentlyTrackedIndex: ControlEvent<Int> {
        let source = controlEvent(.valueChanged)
            .compactMap { [weak base] in base?.currentlyTrackedIndex }
            .asObservable()

        return ControlEvent(events: source)
    }    
}
