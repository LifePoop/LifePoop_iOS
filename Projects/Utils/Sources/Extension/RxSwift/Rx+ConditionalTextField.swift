//
//  Rx+ConditionalTextField.swift
//  Utils
//
//  Created by 이준우 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//
import DesignSystem

import RxCocoa
import RxSwift

extension Reactive where Base == ConditionalTextField {
    
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
