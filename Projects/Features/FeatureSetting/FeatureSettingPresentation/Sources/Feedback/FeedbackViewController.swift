//
//  FeedbackViewController.swift
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

public final class FeedbackViewController: LifePoopViewController, ViewType {
    
    public var viewModel: FeedbackViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: FeedbackViewModel) {
        let input = viewModel.input
        
    }
    
    public func bindOutput(from viewModel: FeedbackViewModel) {
        let output = viewModel.output
        
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        title = "의견 보내기"
    }
    
    public override func layoutUI() {
        super.layoutUI()
        
    }
}
