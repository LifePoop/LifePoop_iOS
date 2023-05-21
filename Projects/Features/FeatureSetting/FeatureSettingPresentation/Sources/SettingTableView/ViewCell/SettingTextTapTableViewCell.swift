//
//  SettingTextTapTableViewCell.swift
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

public final class SettingTextTapTableViewCell: BaseSettingTextTapTableViewCell, ViewType {
    
    public var viewModel: SettingTextTapCellViewModel?
    private var disposeBag = DisposeBag()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func bindInput(to viewModel: SettingTextTapCellViewModel) {
        let input = viewModel.input
        
        input.cellDidDequeue.accept(())
    }
    
    public func bindOutput(from viewModel: SettingTextTapCellViewModel) {
        let output = viewModel.output
        
        output.settingDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.text
            .bind(to: addtionalTextLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
//    public override func handleCellDidTap() {
//        viewModel?.input.cellDidTap.accept(())
//    }
}
