//
//  ProfileViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class ProfileViewController: LifePoopViewController, ViewType {
    
    public var viewModel: ProfileViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: ProfileViewModel) {
        let input = viewModel.input
        
    }
    
    public func bindOutput(from viewModel: ProfileViewModel) {
        let output = viewModel.output
        
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        title = "프로필 정보 수정"
    }
    
    public override func layoutUI() {
        super.layoutUI()
        
    }
}
