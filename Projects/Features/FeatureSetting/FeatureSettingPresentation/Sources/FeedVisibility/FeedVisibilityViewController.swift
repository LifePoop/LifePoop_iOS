//
//  FeedVisibilityViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem
import Utils

public final class FeedVisibilityViewController: LifePoopViewController, ViewType {
    
    private let feedVisibilityButtons = FeedVisibility.allCases.enumerated().map { (index, element) in
        let buttonView = FeedVisibilitySelectionButtonView(index: index, title: element.text)
        buttonView.descriptionLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return buttonView
    }
    
    private lazy var feedVisibilitySelectStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: feedVisibilityButtons)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 26
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public var viewModel: FeedVisibilityViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: FeedVisibilityViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let selectedFeedVisibilityIndex = feedVisibilityButtons.map { button in
            button.containerButton.rx.tap.map { button.index }
        }
        Observable.merge(selectedFeedVisibilityIndex)
            .bind(to: input.feedVisibilityDidSelectAt)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FeedVisibilityViewModel) {
        let output = viewModel.output
        
        output.selectFeedVisibilityAt
            .withUnretained(self)
            .bind { `self`, index in
                self.feedVisibilityButtons.forEach { $0.toggleRadioButton(isSelected: false) }
                self.feedVisibilityButtons[index].toggleRadioButton(isSelected: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(feedVisibilitySelectStackView)
        
        feedVisibilitySelectStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.centerY.equalToSuperview().multipliedBy(0.9)
        }
    }
}
