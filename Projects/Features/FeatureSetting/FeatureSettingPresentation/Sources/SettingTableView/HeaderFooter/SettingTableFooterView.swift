//
//  SettingTableFooterView.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class SettingTableFooterView: UITableViewHeaderFooterView, ViewType {
    
    public lazy var logOutButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(
            string: LocalizableString.signOut,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: ColorAsset.pooPink.color,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    public lazy var withdrawalButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(
            string: LocalizableString.withdraw,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: ColorAsset.gray600.color,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private var disposeBag = DisposeBag()
    public var viewModel: SettingTableFooterViewModel?
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func bindInput(to viewModel: SettingTableFooterViewModel) {
        let input = viewModel.input
        
        logOutButton.rx.tap
            .bind(to: input.logOutButtonDidTap)
            .disposed(by: disposeBag)
        
        withdrawalButton.rx.tap
            .bind(to: input.withdrawalButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SettingTableFooterViewModel) {
        
    }
}

// MARK: - Layout UI

private extension SettingTableFooterView {
    func layoutUI() {
        addSubview(logOutButton)
        addSubview(withdrawalButton)
        
        logOutButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(26)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.leading.equalToSuperview().offset(26)
        }
    }
}
