//
//  LifePoopTextFieldAlertView+Reactive.swift
//  DesignSystemReactive
//
//  Created by Lee, Joon Woo on 2023/06/16.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import DesignSystem

public extension Reactive where Base == LifePoopTextFieldAlertView {
    
    var text: ControlProperty<String> {
        base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { $0.text ?? "" },
            setter: { textFieldAlertView, text in
                textFieldAlertView.text = text
            }
        )
    }
}
