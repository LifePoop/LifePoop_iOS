//
//  BottomSheetDelegate.swift
//  DesignSystem
//
//  Created by 이준우 on 2023/06/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

@objc public protocol BottomSheetDelegate {
    
    @objc optional func bottomSheetDidAppear()
    @objc optional func bottomSheetDidDisappear()
}
