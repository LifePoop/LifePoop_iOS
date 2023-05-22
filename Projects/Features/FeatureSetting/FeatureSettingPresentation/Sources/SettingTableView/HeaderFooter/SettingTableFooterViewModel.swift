//
//  SettingTableFooterViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxRelay
import RxSwift

import FeatureSettingCoordinatorInterface
import Utils

public final class SettingTableFooterViewModel: ViewModelType {
    
    public struct Input {
        let logOutButtonDidTap = PublishRelay<Void>()
        let withdrawalButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        
    }
    
    public let input = Input()
    public let output = Output()
    
    public init() { }
}
