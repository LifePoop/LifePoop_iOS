//
//  FriendListViewController.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/12.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit

import DesignSystem
import Utils

public final class FriendListViewController: LifePoopViewController, ViewType {
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private let rightBarButtonItem = UIBarButtonItem(image: ImageAsset.iconAdd.original)
    
    private lazy var friendListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            FriendListCollectionViewCell.self,
            forCellWithReuseIdentifier: FriendListCollectionViewCell.identifier
        )
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 30, left: .zero, bottom: 16, right: .zero)
        return collectionView
    }()
    
    private let emptyFriendListView: EmptyStoolCharacterView = {
        let emptyStoolCharacterView = EmptyStoolCharacterView(
            descriptionText: LocalizableString.inviteFriendsAndEncourageBowelMovements
        )
        emptyStoolCharacterView.isHidden = true
        return emptyStoolCharacterView
    }()
    
    private let toastLabel: ToastLabel = {
        let label = ToastLabel()
        label.backgroundColor = ColorAsset.gray900.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = ColorAsset.white.color
        return label
    }()
    
    private var disposeBag = DisposeBag()
    public var viewModel: FriendListViewModel?

    public func bindInput(to viewModel: FriendListViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        rightBarButtonItem.rx.tap
            .bind(to: input.invitationButtonDidTap)
            .disposed(by: disposeBag)
        
        friendListCollectionView.rx.itemSelected
            .bind(to: input.friendDidSelect)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FriendListViewModel) {
        let output = viewModel.output
        
        output.setLoadingIndicatorAnimating
            .asSignal()
            .distinctUntilChanged()
            .emit(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.showEmptyList
            .asSignal()
            .withUnretained(self)
            .emit(onNext: { `self`, _ in
                self.friendListCollectionView.isHidden = true
                self.emptyFriendListView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        output.showFriendList
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] _ in
                self?.emptyFriendListView.isHidden = true
                self?.friendListCollectionView.isHidden = false
            })
            .bind(to: friendListCollectionView.rx.items(
                cellIdentifier: FriendListCollectionViewCell.identifier,
                cellType: FriendListCollectionViewCell.self)
            ) { _, friend, cell in
                cell.configure(with: friend)
            }
            .disposed(by: disposeBag)
        
        output.showToastMessge
            .asSignal()
            .map { message in
                let fullString = NSMutableAttributedString()
                
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(systemName: message.systemImageName)?
                                            .withTintColor(ColorAsset.white.color)
                fullString.append(NSAttributedString(attachment: imageAttachment))
            
                fullString.appendSpacing(withPointOf: 12)
                fullString.append(NSAttributedString(string: message.localized))

                return (message: fullString, backgroundColor: UIColor.toastMessage(message))
            }
            .emit(onNext: toastLabel.show(message:backgroundColor:))
            .disposed(by: disposeBag)
    }
    
    public override func configureUI() {
        super.configureUI()
        title = LocalizableString.friendsList
        navigationController?.setNavigationBarHidden(false, animated: false)
        let spacer = UIBarButtonItem.fixedSpace(14)
        navigationItem.rightBarButtonItems = [spacer, rightBarButtonItem]
    }
    
    public override func layoutUI() {
        super.layoutUI()
        defer {
            view.bringSubviewToFront(loadingIndicator)
            view.bringSubviewToFront(toastLabel)
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(friendListCollectionView)
        friendListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(emptyFriendListView)
        emptyFriendListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
    }
}

extension FriendListViewController: UICollectionViewDelegateFlowLayout {
    
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let cellWidth = collectionView.bounds.width
        let cellHeight: CGFloat = 50
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension UIColor {
    
    static func toastMessage(_ toastMessage: ToastMessage) -> UIColor {
        switch toastMessage.kind {
        case .success:
            return ColorAsset.gray900.color
        case .failure:
            return ColorAsset.toastFailure.color
        }
    }
}
