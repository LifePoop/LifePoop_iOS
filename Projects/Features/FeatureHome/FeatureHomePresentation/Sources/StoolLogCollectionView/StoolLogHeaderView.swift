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
        view.isHidden = true
        view.addGestureRecognizer(inviteFriendViewTapGesture)
        return view
    }()
    
    private let cheeringButtonView = CheeringButtonView()
    
    var viewModel: StoolLogHeaderViewModel?
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        output.toggleFriendListCollectionView
            .asSignal()
            .withUnretained(self)
            .emit { `self`, isHidden in
                self.toggleFriendListCollectionView(isHidden: isHidden)
            }
            .disposed(by: disposeBag)
        
        output.updateFriends
            .asSignal()
            .emit(onNext: friendListCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.setDateDescription
            .bind(to: todayStoolLogLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.setFriendsCheeringDescription
            .bind(to: cheeringButtonView.rx.titleText)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Layout

private extension StoolLogHeaderView {
    func layoutUI() {
        addSubview(collectionViewTopSeparatorView)
        addSubview(collectionViewBottonSeparatorView)
        addSubview(friendListCollectionView)
        addSubview(todayStoolLogLabel)
        addSubview(inviteFriendView)
        addSubview(cheeringButtonView)
        
        collectionViewTopSeparatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
        }
        
        collectionViewBottonSeparatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
        }
        
        friendListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewTopSeparatorView.snp.bottom)
            make.bottom.equalTo(collectionViewBottonSeparatorView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(102)
        }
        
        todayStoolLogLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionViewBottonSeparatorView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        cheeringButtonView.snp.makeConstraints { make in
            make.top.equalTo(todayStoolLogLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
        }
            
        inviteFriendView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewTopSeparatorView.snp.bottom)
            make.bottom.equalTo(collectionViewBottonSeparatorView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(102)
        }
    }
}

private extension StoolLogHeaderView {
    func toggleFriendListCollectionView(isHidden: Bool) {
        friendListCollectionView.isHidden = isHidden
        cheeringButtonView.isHidden = isHidden
        inviteFriendView.isHidden = !isHidden
    }
}
