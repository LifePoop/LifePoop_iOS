//
//  ConditionalTextField+Reactive.swift
//  DesignSystemReactive
//
//  Created by 김상혁 on 2023/06/06.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import DesignSystem

public extension Reactive where Base == ConditionalTextField { // FIXME: 공통 모듈로 분리
    var text: ControlProperty<String> {
        base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { $0.text ?? "" },
            setter: { insertField, text in
                insertField.text = text
            }
        )
    }
}
