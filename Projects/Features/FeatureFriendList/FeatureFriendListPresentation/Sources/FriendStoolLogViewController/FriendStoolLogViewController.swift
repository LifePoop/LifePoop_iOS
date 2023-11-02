//
//  FriendStoolLogViewController.swift
//  FeatureFriendListPresentation
//
//  Created by 김상혁 on 2023/09/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class FriendStoolLogViewController: LifePoopViewController, ViewType {
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private lazy var friendstoolLogCollectionViewDiffableDataSource = FriendStoolLogCollectionViewDiffableDataSource(
        collectionView: stoolLogCollectionView
    )
    private let stoolLogCollectionViewSectionLayout = FriendStoolLogCollectionViewSectionLayout()
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
            FriendStoolLogCollectionViewCell.self,
            forCellWithReuseIdentifier: FriendStoolLogCollectionViewCell.identifier
        )
        collectionView.register(
            FriendStoolLogHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FriendStoolLogHeaderView.identifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 28, left: .zero, bottom: 24, right: .zero)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private let toastMessageLabel = ToastLabel()
    
    public var viewModel: FriendStoolLogViewModel?
    private let disposeBag = DisposeBag()
    
    public func bindInput(to viewModel: FriendStoolLogViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FriendStoolLogViewModel) {
        let output = viewModel.output
        
        output.shouldLoadingIndicatorAnimating
            .distinctUntilChanged()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.updateStoolLogs
            .asSignal()
            .emit(onNext: friendstoolLogCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .asSignal()
            .emit(onNext: toastMessageLabel.show(message:))
            .disposed(by: disposeBag)
        
        output.updateFriendStoolLogheaderViewModel
            .asSignal()
            .emit(onNext: friendstoolLogCollectionViewDiffableDataSource.configureHeaderView(with:))
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }
    
    public override func layoutUI() {
        super.layoutUI()
        defer {
            view.bringSubviewToFront(loadingIndicator)
            view.bringSubviewToFront(toastMessageLabel)
        }
        
        view.addSubview(loadingIndicator)
        view.addSubview(stoolLogCollectionView)
        view.addSubview(toastMessageLabel)
        
        loadingIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stoolLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
}
