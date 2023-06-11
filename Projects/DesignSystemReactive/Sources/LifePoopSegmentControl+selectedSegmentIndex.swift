//
//  LifePoopSegmentControl+selectedSegmentIndex.swift
//  DesignSystemReactive
//
//  Created by 김상혁 on 2023/06/11.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import DesignSystem

public extension Reactive where Base == LifePoopSegmentControl {
    var selectedSegmentIndex: ControlProperty<Int?> {
        base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { $0.selectedSegmentIndex },
            setter: { segmentControl, index in
                guard let index else { return }
                segmentControl.selectSegment(at: index)
            }
        )
    }
}
