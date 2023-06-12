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
    ///   - count: The target count for the animation. Must be greater than 0.
    ///   - duration: The duration of the animation in seconds. Must be greater than 0. Default is 0.75.
    ///   - suffix: The suffix to append to the animated count. Default is an empty string.
    ///
    /// - Important:
    ///   - The `count` parameter must be greater than 0.
    ///   - The `duration` parameter must be greater than 0.
    func startCountingAnimation(count: Int, duration: Double = 0.5, suffix: String = "") {
        guard duration > 0 else {
            Logger.log(message: "duration은 0보다 커야합니다.", category: .default, type: .error)
            return
        }
        guard count > 0 else {
            Logger.log(message: "count는 0보다 커야합니다.", category: .default, type: .error)
            return
        }
        
        let initialCount: Double = 0.0
        let finalCount: Double = Double(count)
        let numberOfSteps: Int = 100
        let timeInterval = duration / Double(numberOfSteps)
        let countIncrement = finalCount - initialCount
        for step in 0...numberOfSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval * Double(step)) {
                let currentCount = Int(initialCount + countIncrement * (Double(step) / Double(numberOfSteps)))
                self.text = "\(currentCount)\(suffix)"
            }
        }
    }
}
