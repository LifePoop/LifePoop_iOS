//
//  SettingSwitchCellViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import Utils

public final class SettingSwitchCellViewModel: SettingCellViewModel {
    
    public struct Input {
        let cellDidDequeue = PublishRelay<Void>()
        let switchDidToggle = PublishRelay<Bool>()
    }
    
    public struct Output {
        let settingDescription = BehaviorRelay<String>(value: "")
        let isSwitchOn: BehaviorRelay<Bool>
    }
    
    public let input = Input()
    public let output: Output
    public let model: SettingModel
    
    private let disposeBag = DisposeBag()
    
    public init(model: SettingModel, isSwitchOn: BehaviorRelay<Bool>, switchToggleAction: PublishRelay<Bool>) {
        self.model = model
        self.output = Output(isSwitchOn: isSwitchOn)
        
        input.cellDidDequeue
            .map { model.description }
            .bind(to: output.settingDescription)
            .disposed(by: disposeBag)
        
        input.switchDidToggle
            .bind(to: switchToggleAction)
            .disposed(by: disposeBag)
    }
}
