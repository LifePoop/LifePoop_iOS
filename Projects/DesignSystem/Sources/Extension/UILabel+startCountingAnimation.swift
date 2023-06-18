//
//  UILabel+startCountingAnimation.swift
//  DesignSystem
//
//  Created by 김상혁 on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation
import UIKit

import Logger

public extension UILabel {
    
    /// `UILabel`에 대해 카운팅 애니메이션을 시작합니다.
    /// - Parameters:
    ///   - targetCount: 애니메이션의 최종 카운트입니다. 0보다 크거나 같아야 합니다.
    ///   - duration: 초 단위의 애니메이션 지속 시간입니다. 0보다 커야 합니다. 기본값은 0.5초입니다.
    ///   - configureTextAction: 각 애니메이션 단계에서 현재 카운트 값으로 호출되는 클로저입니다.
    ///                          해당 클로저에서 UILabel의 `text` 또는 `attributedText`를 변경하는 코드를 작성할 수 있습니다.
    ///
    /// - Important:
    ///   - `targetCount` 매개변수는 반드시 0보다 크거나 같아야 합니다.
    ///   - `duration` 매개변수는 반드시 0보다 커야 합니다.
    func startCountingAnimation(
        upTo targetCount: Int,
        duration: Double = 0.5,
        configureTextAction: @escaping (_ animatingCount: Int) -> Void
    ) {
        guard duration > 0 else {
            Logger.log(message: "duration은 0보다 커야합니다.", category: .default, type: .error)
            return
        }
        
        guard targetCount >= 0 else {
            Logger.log(message: "count는 0보다 크거나 같아야합니다.", category: .default, type: .error)
            return
        }
        
        if targetCount == 0 {
            configureTextAction(targetCount)
            return
        }
        
        let initialCount: Double = 0.0
        let finalCount: Double = Double(targetCount)
        let numberOfSteps: Int = 100
        let timeInterval = duration / Double(numberOfSteps)
        let countIncrement = finalCount - initialCount
        for step in 0...numberOfSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval * Double(step)) {
                let currentCount = Int(initialCount + countIncrement * (Double(step) / Double(numberOfSteps)))
                configureTextAction(currentCount)
            }
        }
    }
}
