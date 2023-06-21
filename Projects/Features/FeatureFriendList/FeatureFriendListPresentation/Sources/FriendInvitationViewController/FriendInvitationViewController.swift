//
//  FriendInvitationViewController.swift
//  FeatureFriendListPresentation
//
//  Created by Lee, Joon Woo on 2023/06/13.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem
import Utils

public final class FrinedInvitationViewController: LifePoopViewController, ViewType {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = ColorAsset.black.color
        return label
    }()
    
    private lazy var invitationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            InvitationCollectionViewCell.self,
            forCellWithReuseIdentifier: InvitationCollectionViewCell.identifier
        )
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        
        return collectionView
    }()

    private var disposeBag = DisposeBag()
    public var viewModel: FriendInvitationViewModel?
    
    public func bindInput(to viewModel: FriendInvitationViewModel) {
        let input = viewModel.input

        invitationCollectionView.rx.modelSelected(InvitationType.self)
            .bind(to: input.didSelectInvitationType)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: FriendInvitationViewModel) {
        let output = viewModel.output
        
        output.navitationTitle
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.invitationTypes
            .bind(to: invitationCollectionView.rx.items(
                cellIdentifier: InvitationCollectionViewCell.identifier,
                cellType: InvitationCollectionViewCell.self)
            ) { _, invitationType, cell in
                cell.configure(with: invitationType)
            }
            .disposed(by: disposeBag)
    }
    
    public override func layoutUI() {
        super.layoutUI()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(invitationCollectionView)
        invitationCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(23)
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.bottom.equalToSuperview()
        }
    }
}

extension FrinedInvitationViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let cellWidth = collectionView.bounds.width
        let cellHeight: CGFloat = 48
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
