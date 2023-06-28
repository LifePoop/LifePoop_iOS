//
//  FriendStoolStoryViewController.swift
//  FeatureHomePresentation
//
//  Created by Lee, Joon Woo on 2023/06/25.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem
import EntityUIMapper
import Utils

public final class FriendStoolStoryViewController: LifePoopViewController, ViewType {
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageAsset.btnClose.original, for: .normal)
        return button
    }()
    
    private let segmentedProgressView: SegmentedProgressView = {
        let view = SegmentedProgressView()
        view.spacingBetweenSegments = 5
        return view
    }()
    
    private let stoolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private let stoolLogSummaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = ColorAsset.white.color
        return label
    }()
    
    private let cheeringLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.cheeringWithBoost
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ColorAsset.white.color
        return label
    }()
    
    private let cheeringButton: LifePoopButton = {
        let button = LifePoopButton(title: LocalizableString.boost)
        button.setTitle(LocalizableString.boost, for: .normal)
        button.setTitle(LocalizableString.doneBoost, for: .disabled)
        
        return button
    }()
    
    public var viewModel: FriendStoolStoryViewModel?
    private var disposeBag = DisposeBag()
    
    public func bindInput(to viewModel: FriendStoolStoryViewModel) {
        let input = viewModel.input
        
        rx.viewDidLayoutSubviews
            .bind(to: input.viewDidLayoutSubviews)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(to: input.didTapCloseButton)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FriendStoolStoryViewModel) {
        let output = viewModel.output
        
        output.stoolStoryLogs
            .map { $0.count }
            .bind(to: segmentedProgressView.rx.numberOfSegments)
            .disposed(by: disposeBag)
        
        output.shouldUpdateProgressState
            .map { $0.currentIndex }
            .bind(to: segmentedProgressView.rx.currentlyTrackedIndex)
            .disposed(by: disposeBag)
        
        output.shouldUpdateShownStoolLog
            .map { $0.stoolImage }
            .bind(to: stoolImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.shouldEnableCheeringButton
            .bind(to: cheeringButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.shouldEnableCheeringButton
            .map { $0 ? LocalizableString.cheeringWithBoost :
                        LocalizableString.doneCheeringWithBoost
            }
            .bind(to: cheeringLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.shouldUpdateFriendStoolLogSummary
            .bind(to: stoolLogSummaryLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.shouldEnableCheeringButton
            .map { $0 ? ColorAsset.white.color : ColorAsset.pooPink.color }
            .bind(to: cheeringLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.shouldEnableCheeringButton
            .map { $0 ? LocalizableString.boost : LocalizableString.doneBoost }
            .asDriver(onErrorJustReturn: LocalizableString.doneBoost)
            .drive(onNext: { [weak self] title in
                self?.cheeringButton.titleLabel?.text = title
            })
            .disposed(by: disposeBag)
    }
    
    public override func layoutUI() {
        super.layoutUI()
        
        let screenWidth = UIScreen.main.bounds.width
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.trailing.equalToSuperview().inset(27)
        }
        
        view.addSubview(segmentedProgressView)
        segmentedProgressView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(27)
            make.height.equalTo(4)
        }
        
        view.addSubview(cheeringButton)
        cheeringButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        view.addSubview(stoolImageView)
        stoolImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(screenWidth*0.8)
        }
        
        view.addSubview(cheeringLabel)
        cheeringLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cheeringButton.snp.top).offset(-27)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(stoolLogSummaryLabel)
        stoolLogSummaryLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cheeringLabel.snp.top).offset(-113)
            make.centerX.equalToSuperview()
        }
    }
    
    public override func configureUI() {
        super.configureUI()
        
        view.backgroundColor = ColorAsset.grayStoryBackground.color
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGeuture(_:))))
    }
    
    @objc private func handleTapGeuture(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: view)
        
        if location.x <= view.frame.width/2 {
            viewModel?.input.didTapScreen.accept(.left)
        } else {
            viewModel?.input.didTapScreen.accept(.right)
        }
    }
}
