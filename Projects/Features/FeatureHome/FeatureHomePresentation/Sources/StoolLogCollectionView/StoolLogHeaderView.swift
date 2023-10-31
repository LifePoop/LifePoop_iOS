//
//  StoolLogHeaderView.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/03.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem
import DesignSystemReactive
import EntityUIMapper
import Utils

final class StoolLogHeaderView: UICollectionReusableView, ViewType {
    
    private let collectionViewTopSeparatorView = SeparatorView()
    private let collectionViewBottonSeparatorView = SeparatorView()
    
    private lazy var storyFeedCollectionViewDiffableDataSource = StoryFeedCollectionViewDiffableDataSource(
        collectionView: storyFeedCollectionView
    )
    private let storyFeedCollectionViewSectionLayout = StoryFeedCollectionViewSectionLayout()
    private lazy var storyFeedCollectionViewLayout: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let compositionalLayout = UICollectionViewCompositionalLayout(
            sectionProvider: storyFeedCollectionViewSectionLayout.sectionProvider,
            configuration: configuration
        )
        return compositionalLayout
    }()
    private lazy var storyFeedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: storyFeedCollectionViewLayout
        )
        collectionView.register(
            StoryFeedCollectionViewCell.self,
            forCellWithReuseIdentifier: StoryFeedCollectionViewCell.identifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    private let todayStoolLogLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let inviteFriendViewTapGesture = UITapGestureRecognizer()
    private lazy var inviteFriendView: InviteFriendView = {
        let view = InviteFriendView()
        view.addGestureRecognizer(inviteFriendViewTapGesture)
        return view
    }()
    
    private let noFriendStoolLogYetView: NoFriendStoolLogYetView = {
        let view = NoFriendStoolLogYetView()
        view.isHidden = true
        return view
    }()
    
    private let cheeringButtonView = CheeringButtonView()
    
    private lazy var cheeringButtonTodayLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todayStoolLogLabel, cheeringButtonView])
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()
    
    var viewModel: StoolLogHeaderViewModel?
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - ViewModel Binding
    
    func bindInput(to viewModel: StoolLogHeaderViewModel) {
        let input = viewModel.input
        
        input.viewDidLoad.accept(())
        
        rx.finishLayoutSubviews
            .bind(to: input.viewDidFinishLayoutSubviews)
            .disposed(by: disposeBag)
        
        cheeringButtonView.rx.tap
            .bind(to: input.cheeringButtonDidTap)
            .disposed(by: disposeBag)
        
        inviteFriendViewTapGesture.rx.event
            .map { _ in }
            .bind(to: input.inviteFriendButtonDidTap)
            .disposed(by: disposeBag)
        
        storyFeedCollectionView.rx.itemSelected
            .bind(to: input.friendListCellDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: StoolLogHeaderViewModel) {
        let output = viewModel.output
        
        output.showInviteFriendUI
            .asSignal()
            .withUnretained(self)
            .emit { `self`, _ in
                self.showInviteFriendUI()
            }
            .disposed(by: disposeBag)
        
        output.isStoryFeedEmpty
            .asSignal()
            .withUnretained(self)
            .emit { `self`, isEmpty in
                self.showStoryFeedUI(by: isEmpty)
            }
            .disposed(by: disposeBag)
        
        output.updateStoryFeeds
            .asSignal()
            .emit(onNext: storyFeedCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.setDateDescription
            .asSignal()
            .emit(to: todayStoolLogLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updateCheeringProfileCharacters
            .asSignal()
            .map { ($0.0?.cheeringImage, $0.1?.cheeringImage) }
            .emit(onNext: cheeringButtonView.showCheeringFriendImage)
            .disposed(by: disposeBag)
        
        output.updateCheeringFriendNameAndCount
            .asSignal()
            .emit(onNext: cheeringButtonView.updateCheeringFriend)
            .disposed(by: disposeBag)
        
        output.showEmptyCheeringInfo
            .asSignal()
            .emit(onNext: cheeringButtonView.showEmptyCheeringFriendImage)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Layout

private extension StoolLogHeaderView {
    func layoutUI() {
        addSubview(collectionViewTopSeparatorView)
        addSubview(storyFeedCollectionView)
        addSubview(inviteFriendView)
        addSubview(noFriendStoolLogYetView)
        addSubview(collectionViewBottonSeparatorView)
        addSubview(cheeringButtonTodayLabelStackView)
        
        collectionViewTopSeparatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        storyFeedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewTopSeparatorView.snp.bottom)
            make.bottom.equalTo(collectionViewBottonSeparatorView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(102)
        }

        inviteFriendView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewTopSeparatorView.snp.bottom)
            make.bottom.equalTo(collectionViewBottonSeparatorView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(102)
        }
        
        noFriendStoolLogYetView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewTopSeparatorView.snp.bottom)
            make.bottom.equalTo(collectionViewBottonSeparatorView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(102)
        }
        
        collectionViewBottonSeparatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        cheeringButtonTodayLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewBottonSeparatorView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
}

private extension StoolLogHeaderView {
    func showInviteFriendUI() {
        inviteFriendView.isHidden = false
        storyFeedCollectionView.isHidden = true
        cheeringButtonView.isHidden = true
        noFriendStoolLogYetView.isHidden = true
    }
    
    func showStoryFeedUI(by isStoryFeedEmpty: Bool) {
        noFriendStoolLogYetView.isHidden = !isStoryFeedEmpty
        storyFeedCollectionView.isHidden = isStoryFeedEmpty
        inviteFriendView.isHidden = true
        cheeringButtonView.isHidden = false
    }
}
