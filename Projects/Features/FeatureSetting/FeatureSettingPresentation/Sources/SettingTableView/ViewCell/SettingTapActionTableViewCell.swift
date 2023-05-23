//
//  SettingTapActionTableViewCell.swift
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

public class SettingTapActionTableViewCell: BaseSettingTableViewCell, ViewType {
    
    public lazy var addtionalTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    public lazy var expandImageView: UIImageView = {
        let imageView = UIImageView(image: ImageAsset.expandRight.original)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }()
    
    public var viewModel: SettingTapActionCellViewModel?
    private var disposeBag = DisposeBag()
    
    override public func configureSelectionStyle() {
        super.configureSelectionStyle()
        addGestureRecognizer(tapGesture)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: SettingTapActionCellViewModel) {
        let input = viewModel.input
        
        input.cellDidDequeue.accept(())
        
        tapGesture.rx.event
            .map { _ in }
            .bind(to: input.cellDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SettingTapActionCellViewModel) {
        let output = viewModel.output
        
        output.settingDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.additionalText?
            .bind(to: addtionalTextLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    override public func layoutUI() {
        super.layoutUI()
        contentView.addSubview(expandImageView)
        contentView.addSubview(addtionalTextLabel)
        
        expandImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-37)
        }
        
        addtionalTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(expandImageView.snp.leading).offset(-4)
        }
    }
}
