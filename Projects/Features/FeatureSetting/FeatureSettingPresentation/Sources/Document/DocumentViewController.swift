//
//  DocumentViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class DocumentViewController: LifePoopViewController, ViewType {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 10, left: 24, bottom: 20, right: 24)
        textView.contentInsetAdjustmentBehavior = .never
        textView.font = .systemFont(ofSize: 12)
        return textView
    }()
    
    public var viewModel: DocumentViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: DocumentViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: DocumentViewModel) {
        let output = viewModel.output
        
        output.title
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        output.documentText
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
