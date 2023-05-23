//
//  SettingTextTableViewCell.swift
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

public final class SettingTextTableViewCell: BaseSettingTableViewCell, ViewType {
    
    private lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    public var viewModel: SettingTextCellViewModel?
    private var disposeBag = DisposeBag()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: SettingTextCellViewModel) {
        let input = viewModel.input
        
        input.cellDidDequeue.accept(())
    }
    
    public func bindOutput(from viewModel: SettingTextCellViewModel) {
        let output = viewModel.output
        
        output.settingDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.text
            .bind(to: settingLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    override public func layoutUI() {
        super.layoutUI()
        contentView.addSubview(settingLabel)
        
        settingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-37)
        }
    }
}
