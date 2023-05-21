//
//  SettingTapTableViewCell.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

import DesignSystem
import Utils

public class SettingTapTableViewCell: BaseSettingTapTableViewCell, ViewType {
    
    public var viewModel: SettingTapCellViewModel?
    private var disposeBag = DisposeBag()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func bindInput(to viewModel: SettingTapCellViewModel) {
        let input = viewModel.input
        
        input.cellDidDequeue.accept(())
        
        tapGesture.rx.event
            .map { _ in }
            .bind(to: input.cellDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SettingTapCellViewModel) {
        let output = viewModel.output
        
        output.settingDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
