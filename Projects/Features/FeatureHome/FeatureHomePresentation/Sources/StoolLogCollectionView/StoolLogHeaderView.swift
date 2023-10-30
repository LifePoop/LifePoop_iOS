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
import Utils

final class StoolLogHeaderView: UICollectionReusableView, ViewType {
    
    private let collectionViewTopSeparatorView = SeparatorView()
    private let collectionViewBottonSeparatorView = SeparatorView()
    
    private lazy var friendListCollectionViewDiffableDataSource = FriendListCollectionViewDiffableDataSource(
        collectionView: friendListCollectionView
    )
    private let friendListCollectionViewSectionLayout = FriendListCollectionViewSectionLayout()
    private lazy var friendListCollectionViewLayout: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let compositionalLayout = UICollectionViewCompositionalLayout(
            sectionProvider: friendListCollectionViewSectionLayout.sectionProvider,
            configuration: configuration
        )
        return compositionalLayout
    }()
    private lazy var friendListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: friendListCollectionViewLayout
        )
        collectionView.register(
            FriendListCollectionViewCell.self,
            forCellWithReuseIdentifier: FriendListCollectionViewCell.identifier
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
        
        friendListCollectionView.rx.itemSelected
            .bind(to: input.friendListCellDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: StoolLogHeaderViewModel) {
        let output = viewModel.output
        
        output.isFriendEmpty
            .asSignal()
            .withUnretained(self)
            .emit { `self`, isEmpty in
                self.toggleFriendListCollectionView(by: isEmpty)
            }
            .disposed(by: disposeBag)
        
        output.updateFriends
            .asSignal()
            .emit(onNext: friendListCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.setDateDescription
            .asSignal()
            .emit(to: todayStoolLogLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.setFriendsCheeringDescription
            .asSignal()
            .emit(to: cheeringButtonView.rx.titleText)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Layout

private extension StoolLogHeaderView {
    func layoutUI() {
        addSubview(collectionViewTopSeparatorView)
        addSubview(friendListCollectionView)
        addSubview(inviteFriendView)
        addSubview(collectionViewBottonSeparatorView)
        addSubview(cheeringButtonTodayLabelStackView)
        
        collectionViewTopSeparatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        friendListCollectionView.snp.makeConstraints { make in
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
    func toggleFriendListCollectionView(by isHidden: Bool) {
        friendListCollectionView.isHidden = isHidden
        inviteFriendView.isHidden = !isHidden
        cheeringButtonView.isHidden = isHidden
    }
}
