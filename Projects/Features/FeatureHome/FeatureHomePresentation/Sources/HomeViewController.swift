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
    
    private lazy var settingBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: ImageAsset.iconSetting.original)
        return barButtonItem
    }()
    
    private lazy var reportBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: ImageAsset.iconReport.original)
        return barButtonItem
    }()
    
    private lazy var lifePoopLogoBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: ImageAsset.logoSmall.original)
        return barButtonItem
    }()
    
    private lazy var collectionViewTopSeparatorView = SeparatorView()
    private lazy var collectionViewBottonSeparatorView = SeparatorView()
    
    private lazy var friendListCollectionViewDiffableDataSource = FriendListCollectionViewDiffableDataSource(
        collectionView: friendListCollectionView
    )
    
    private lazy var friendListCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 16, left: .zero, bottom: 16, right: 24)
        layout.minimumLineSpacing = 14
        return layout
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
        return collectionView
    }()
    
    private lazy var stoolLogCollectionViewDiffableDataSource = StoolLogCollectionViewDiffableDataSource(
        collectionView: stoolLogCollectionView
    )
    private let stoolLogSectionLayout = StoolLogCollectionViewSectionLayout()
    private lazy var stoolLogCollectionViewLayout: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let compositionalLayout = UICollectionViewCompositionalLayout(
            sectionProvider: stoolLogSectionLayout.sectionProvider,
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
    
    private lazy var logButton = LogButton()
    
    public var viewModel: HomeViewModel?
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stoolLogSectionLayout.collectionViewSize = stoolLogCollectionView.bounds.size
    }
    
    public func bindInput(to viewModel: HomeViewModel) {
        let input = viewModel.input
        
    }
    
    public func bindOutput(from viewModel: HomeViewModel) {
        let output = viewModel.output
        
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
        view.addSubview(logButton)
        
        collectionViewTopSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(friendListCollectionView)
            make.bottom.equalTo(friendListCollectionView.snp.top)
        }
        
        collectionViewBottonSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(friendListCollectionView)
            make.top.equalTo(friendListCollectionView.snp.bottom)
        }
        
        friendListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(friendListCollectionViewLayout.layoutHeight)
        }
        
        stoolLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewBottonSeparatorView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
        
        logButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-46)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
}
