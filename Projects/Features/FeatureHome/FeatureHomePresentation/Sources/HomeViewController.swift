//
//  HomeViewController.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class HomeViewController: UIViewController, ViewType {
    
    private let settingBarButtonItem = UIBarButtonItem(image: ImageAsset.iconSetting.original)
    private let reportBarButtonItem = UIBarButtonItem(image: ImageAsset.iconReport.original)
    private let lifePoopLogoBarButtonItem = UIBarButtonItem(image: ImageAsset.logoSmall.original)
    
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
    
    private lazy var stoolLogCollectionViewDiffableDataSource = StoolLogCollectionViewDiffableDataSource(
        collectionView: stoolLogCollectionView
    )
    private let stoolLogCollectionViewSectionLayout = StoolLogCollectionViewSectionLayout()
    private lazy var stoolLogCollectionViewLayout: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let compositionalLayout = UICollectionViewCompositionalLayout(
            sectionProvider: stoolLogCollectionViewSectionLayout.sectionProvider,
            configuration: configuration
        )
        return compositionalLayout
    }()
    private lazy var stoolLogCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: stoolLogCollectionViewLayout
        )
        collectionView.register(
            StoolLogCollectionViewCell.self,
            forCellWithReuseIdentifier: StoolLogCollectionViewCell.identifier
        )
        collectionView.register(
            StoolLogHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StoolLogHeaderView.identifier
        )
        collectionView.contentInset = .zero
        return collectionView
    }()
    
    private let stoolLogButton = LifePoopButton(title: "변 기록하기")
    
    public var viewModel: HomeViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    public func bindInput(to viewModel: HomeViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        settingBarButtonItem.rx.tap
            .bind(to: input.settingButtonDidTap)
            .disposed(by: disposeBag)
        
        reportBarButtonItem.rx.tap
            .bind(to: input.reportButtonDidTap)
            .disposed(by: disposeBag)
        
        stoolLogButton.rx.tap
            .bind(to: input.stoolLogButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: HomeViewModel) {
        let output = viewModel.output
        
        output.friends
            .asDriver()
            .drive(onNext: friendListCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.stoolLogs
            .asDriver()
            .drive(onNext: stoolLogCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension HomeViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = lifePoopLogoBarButtonItem
        navigationItem.rightBarButtonItems = [reportBarButtonItem, settingBarButtonItem]
    }
}

// MARK: - UI Layout

private extension HomeViewController {
    func layoutUI() {
        view.addSubview(collectionViewTopSeparatorView)
        view.addSubview(collectionViewBottonSeparatorView)
        view.addSubview(friendListCollectionView)
        view.addSubview(stoolLogCollectionView)
        view.addSubview(stoolLogButton)
        
        collectionViewTopSeparatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(friendListCollectionView.snp.top)
        }
        
        collectionViewBottonSeparatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.top.equalTo(friendListCollectionView.snp.bottom)
        }
        
        friendListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(102)
        }
        
        stoolLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewBottonSeparatorView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        stoolLogButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }
}
