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
    
    private let friendStoolLogTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "이길동님의 변 기록이에요\n아직 이길동님이 변하지 않았어요"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
//    private let cheeringFriendView = CheeringProfileCharacterView()
    
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
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: 24, right: .zero)
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
        
        output.updateStoolLogs // FIXME: updateStoolLogs 이벤트가 전달되지 않을 경우 홈 화면에 아무것도 나오지 않는 문제 수정
            .asSignal()
            .emit(onNext: friendstoolLogCollectionViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .asSignal()
            .emit(onNext: toastMessageLabel.show(message:)) // TODO: ToastLabel을 친구 코드 복사 화면의 것과 통일하기
            .disposed(by: disposeBag)
        
        
//        cheeringFriendView.setCheeringFriendProfileCharacter(
//            images: ImageAsset.profileCheeringGoodRed.original,
//            ImageAsset.profileCheeringGoodBlack.original
//        )

//        output.showCheeringInfo
//            .asSignal()
//            .withUnretained(self)
//            .emit { `self`, cheeringInfo in
//                self.cheeringFriendView.setCheeringFriendProfileCharacter(images: [
//                    ImageAsset.profileCheeringGoodRed,
//                    ImageAsset.profileCheeringGoodBlack,
//                ])
//            }
//            .disposed(by: disposeBag)
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
        view.addSubview(friendStoolLogTitleLabel)
        view.addSubview(stoolLogCollectionView)
        view.addSubview(toastMessageLabel)
        
        loadingIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        friendStoolLogTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        stoolLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(friendStoolLogTitleLabel.snp.bottom).offset(22)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
}
