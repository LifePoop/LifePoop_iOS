//
//  SettingTapActionCellViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import Utils

public final class SettingTapActionCellViewModel: SettingCellViewModel {
    
    public struct Input {
        let cellDidDequeue = PublishRelay<Void>()
        let cellDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let settingDescription = BehaviorRelay<String>(value: "")
        let additionalText = BehaviorRelay<String>(value: "")
    }
    
    public let input = Input()
    public let output = Output()
    public let model: SettingModel
    
    private let disposeBag = DisposeBag()
    
    public init(model: SettingModel, tapAction: PublishRelay<Void>) {
        self.model = model
        
        input.cellDidDequeue
            .map { model.description }
            .bind(to: output.settingDescription)
            .disposed(by: disposeBag)
        
        input.cellDidTap
            .bind(to: tapAction)
            .disposed(by: disposeBag)
    }
    
    public func bindCellText(with relay: BehaviorRelay<String>) {
        relay
            .bind(to: output.additionalText)
            .disposed(by: disposeBag)
    }
}
