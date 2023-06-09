//
//  ConditionSelectionView+Reactive.swift
//  FeatureLoginPresentation
//
//  Created by Lee, Joon Woo on 2023/06/11.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: ConditionSelectionView {
    
    var check: ControlEvent<Bool> {
        let source = base.rx.controlEvent(.valueChanged).map { base.isChecked }
        return ControlEvent(events: source)
    }
}
