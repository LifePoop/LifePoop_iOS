//
//  SettingLoginTypeTableViewCell.swift
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

public final class SettingLoginTypeTableViewCell: BaseSettingTableViewCell, ViewType {
    
    private lazy var loginTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public var viewModel: SettingLoginTypeCellViewModel?
    private var disposeBag = DisposeBag()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: SettingLoginTypeCellViewModel) {
        let input = viewModel.input
        
        input.cellDidDequeue.accept(())
    }
    
    public func bindOutput(from viewModel: SettingLoginTypeCellViewModel) {
        let output = viewModel.output
        
        output.settingDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.loginType
            .map {
                switch $0 {
                case .apple:
                    return ImageAsset.loginApple.original
                case .kakao:
                    return ImageAsset.loginKakao.original
                case .none:
                    return UIImage()
                }
            }
            .bind(to: loginTypeImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    override public func layoutUI() {
        super.layoutUI()
        contentView.addSubview(loginTypeImageView)
        
        loginTypeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-37)
        }
    }
}
