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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ColorAsset.white.color
        label.text = "N분 전"
        return label
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
        let button = LifePoopButton()
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
            .bind(to: input.closeButtonDidTap)
            .disposed(by: disposeBag)
        
        segmentedProgressView.rx.currentlyTrackedIndex
            .bind(to: input.progressStateDidUpdate)
            .disposed(by: disposeBag)
        
        segmentedProgressView.rx.progressDidEnd
            .filter { $0 }
            .mapToVoid()
            .bind(to: input.closeButtonDidTap)
            .disposed(by: disposeBag)
        
        cheeringButton.rx.tap
            .bind(to: input.cheeringButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FriendStoolStoryViewModel) {
        let output = viewModel.output
        
        output.stories
            .map { $0.count }
            .bind(to: segmentedProgressView.rx.numberOfSegments)
            .disposed(by: disposeBag)
        
        // MARK: currentlyTrackedIndex의 Binder 타입으로 바로 이벤트 방출시키지 발 것
        output.updateProgressState
            .bind(onNext: segmentedProgressView.manuallyTrackSegment(forIndexOf:))
            .disposed(by: disposeBag)
        
        output.updateShownStory
            .map { $0.stoolImage }
            .bind(to: stoolImageView.rx.image)
            .disposed(by: disposeBag)
                
        output.enableCheeringButton
            .bind(to: cheeringButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.updateCheeringLabelText
            .bind(to: cheeringLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updateFriendStoolLogSummary
            .bind(to: stoolLogSummaryLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updateStoolLogTime
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.showLoadingIndicator
            .asSignal()
            .withUnretained(self)
            .emit(onNext: { `self`, shouldShowLoadingIndicator in
                if shouldShowLoadingIndicator {
                    self.cheeringButton.showLoadingIndicator()
                } else {
                    self.cheeringButton.hideLoadingIndicator()
                }
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
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalTo(segmentedProgressView.snp.bottom).offset(24)
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
        
        view.backgroundColor = ColorAsset.gray800.color
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGeuture(_:))))
    }
    
    @objc private func handleTapGeuture(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: view)
        let didTapCheeringButton = cheeringButton.frame.contains(location)
        
        if didTapCheeringButton { return }
        if location.x <= view.frame.width/2 {
            viewModel?.input.screenDidTap.accept(.left)
        } else {
            viewModel?.input.screenDidTap.accept(.right)
        }
    }
}
