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

public final class HomeViewController: LifePoopViewController, ViewType {
    
    private let settingBarButtonItem = UIBarButtonItem(image: ImageAsset.iconSetting.original)
    private let reportBarButtonItem = UIBarButtonItem(image: ImageAsset.iconReport.original)
    
    private let lifePoopLogoBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: ImageAsset.logoSmall.original)
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    private let stoolLogRefreshControl = UIRefreshControl()
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
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: 80, right: .zero)
        collectionView.refreshControl = stoolLogRefreshControl
        collectionView.delegate = self
        return collectionView
    }()
    
    private let stoolLogButton: LifePoopButton = {
        let button = LifePoopButton()
        button.setTitle(LocalizableString.logStoolDiary, for: .normal)
        return button
    }()
    
    private let footerLabel: AlphaChangingFooterLabel = {
        let label = AlphaChangingFooterLabel()
        label.text = LocalizableString.checkedLast7DaysStoolLogs
        return label
    }()
    
    public var viewModel: HomeViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: HomeViewModel) {
        let input = viewModel.input
        
        rx.viewWillAppear
            .bind(to: input.viewWillAppear)
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        stoolLogRefreshControl.rx.controlEvent(.valueChanged)
            .delay(.milliseconds(1000), scheduler: MainScheduler.asyncInstance) // FIXME: 서버 UseCase 연결 후 삭제
            .bind(to: input.viewDidRefresh)
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
        
        output.shouldStartRefreshIndicatorAnimation
            .bind(to: stoolLogRefreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
            .disposed(by: disposeBag)
        
        output.updateStoolLogs
            .asSignal()
            .emit(onNext: stoolLogCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.bindStoolLogHeaderViewModel
            .asSignal()
            .emit(onNext: stoolLogCollectionViewDiffableDataSource.bindStoolLogHeaderView)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = lifePoopLogoBarButtonItem
        navigationItem.rightBarButtonItems = [settingBarButtonItem, reportBarButtonItem]
    }
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(stoolLogCollectionView)
        view.addSubview(stoolLogButton)
        view.addSubview(footerLabel)
        
        stoolLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        stoolLogButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        footerLabel.snp.makeConstraints { make in
             make.leading.trailing.equalToSuperview()
             make.bottom.equalTo(stoolLogButton.snp.top).offset(-24)
         }

// MARK: - UICollectionViewDelegate Methods

extension HomeViewController: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        footerLabel.adjustAlphaBasedOnOffset(offsetY, contentHeight: contentHeight, frameHeight: frameHeight)
    }
}

private extension HomeViewController {
    }
}
