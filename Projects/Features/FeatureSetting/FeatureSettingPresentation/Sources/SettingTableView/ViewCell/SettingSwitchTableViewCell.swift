//
//  SettingSwitchTableViewCell.swift
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

public final class SettingSwitchTableViewCell: BaseSettingTableViewCell, ViewType {
    
    private lazy var settingSwitch: UISwitch = {
        let `switch` = UISwitch()
        `switch`.onTintColor = ColorAsset.primary.color
        return `switch`
    }()
    
    public var viewModel: SettingSwitchCellViewModel?
    private var disposeBag = DisposeBag()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func bindInput(to viewModel: SettingSwitchCellViewModel) {
        let input = viewModel.input
        
        input.cellDidDequeue.accept(())
    }
    
    public func bindOutput(from viewModel: SettingSwitchCellViewModel) {
        let output = viewModel.output
        
        output.settingDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isSwitchOn
            .bind(to: settingSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    override public func layoutUI() {
        super.layoutUI()
        contentView.addSubview(settingSwitch)
        
        settingSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-37)
        }
    }
}
