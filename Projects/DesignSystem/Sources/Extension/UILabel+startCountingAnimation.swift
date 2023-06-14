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
    
    /// Starts the counting animation for the label.
    /// - Parameters:
    ///   - targetCount: The final count for the animation. Must be greater than or equal to 0.
    ///   - duration: The duration of the animation in seconds. Must be greater than 0. Default is 0.5.
    ///   - configureTextAction: A closure that is invoked on each animation step with the current count value.
    ///
    /// - Important:
    ///   - The `targetCount` parameter must be equal to or greater than 0.
    ///   - The `duration` parameter must be greater than 0.
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
