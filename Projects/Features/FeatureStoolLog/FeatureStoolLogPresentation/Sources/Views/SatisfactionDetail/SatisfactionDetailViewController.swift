//
//  SatisfactionDetailViewController.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit

import CoreEntity
import DesignSystem
import Utils

public final class SatisfactionDetailViewController: UIViewController, ViewType {
    
    private let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: ImageAsset.expandLeft.original)
    
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "색깔"
        return label
    }()
    
    private let stiffnessTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "강도"
        return label
    }()

    private let sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "크기"
        return label
    }()
    
    private lazy var colorSelectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 27
        layout.itemSize = .init(width: 24, height: 24)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorSelectionCell.self, forCellWithReuseIdentifier: ColorSelectionCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    private lazy var stiffnessSelectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 39
        layout.itemSize = .init(width: 34, height: 58)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            StiffnessSelectionCell.self,
            forCellWithReuseIdentifier: StiffnessSelectionCell.identifier
        )
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private lazy var sizeSelectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 38
        layout.itemSize = .init(width: 35, height: 46)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SizeSelectionCell.self,
            forCellWithReuseIdentifier: SizeSelectionCell.identifier
        )
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(ColorAsset.white.color, for: .normal)
        button.backgroundColor = ColorAsset.primary.color
        button.roundCorners(12)
        return button
    }()
    
    public var viewModel: SatisfactionDetailViewModel?
    private var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
    }
    
    public func bindInput(to viewModel: SatisfactionDetailViewModel) {
        let input = viewModel.input
        
        leftBarButton.rx.tap
            .bind(to: input.didTapLeftBarbutton)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind(to: input.didTapCompleteButton)
            .disposed(by: disposeBag)
        
        colorSelectCollectionView.rx.modelSelected(SelectableColor.self)
            .bind(to: input.didSelectColor)
            .disposed(by: disposeBag)
        
        stiffnessSelectCollectionView.rx.modelSelected(SelectableStiffness.self)
            .bind(to: input.didSelectStiffness)
            .disposed(by: disposeBag)

        sizeSelectionCollectionView.rx.modelSelected(SelectableSize.self)
            .bind(to: input.didSelectSize)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SatisfactionDetailViewModel) {
        let output = viewModel.output
        
        output.titleText
            .asDriver()
            .drive(onNext: { [weak self] title in
                let titleLabel = UILabel()
                titleLabel.text = title
                titleLabel.font = UIFont.systemFont(ofSize: 18)
                titleLabel.textColor = ColorAsset.black.color
                self?.navigationItem.titleView = titleLabel
            })
            .disposed(by: disposeBag)
        
        output.selectableColors
            .bind(to: colorSelectCollectionView.rx.items(
                cellIdentifier: ColorSelectionCell.identifier,
                cellType: ColorSelectionCell.self)
            ) { _, color, cell in
                cell.configure(selectableColor: color)
            }
            .disposed(by: disposeBag)
        
        output.selectableStiffnessList
            .bind(to: stiffnessSelectCollectionView.rx.items(
                cellIdentifier: StiffnessSelectionCell.identifier,
                cellType: StiffnessSelectionCell.self)
            ) { _, stiffness, cell in
                cell.configure(stiffnessSelection: stiffness)
            }
            .disposed(by: disposeBag)
        
        output.selectableSizes
            .bind(to: sizeSelectionCollectionView.rx.items(
                cellIdentifier: SizeSelectionCell.identifier,
                cellType: SizeSelectionCell.self)
            ) { _, size, cell in
                cell.configure(sizeSelection: size)
            }
            .disposed(by: disposeBag)
    }
}

private extension SatisfactionDetailViewController {
    
    func configureUI() {
        setAttributes()
        addSubViews()
    }
    
    func setAttributes() {
        view.backgroundColor = .systemBackground
    }
    
    func addSubViews() {
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(46)
            make.height.equalTo(54)
        }

        let viewHeight = view.frame.height

        view.addSubview(stiffnessTitleLabel)
        stiffnessTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(39)
            make.top.equalToSuperview().offset(viewHeight*0.38)
        }
        
        view.addSubview(stiffnessSelectCollectionView)
        stiffnessSelectCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(stiffnessTitleLabel.snp.trailing).offset(52)
            make.centerY.equalTo(stiffnessTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(79)
            make.height.equalTo(58)
        }
        
        view.addSubview(colorTitleLabel)
        colorTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(39)
            make.bottom.equalTo(stiffnessTitleLabel.snp.top).offset(-viewHeight*0.167)
        }
        
        view.addSubview(colorSelectCollectionView)
        colorSelectCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(colorTitleLabel.snp.centerY)
            make.leading.equalTo(colorTitleLabel.snp.trailing).offset(29)
            make.trailing.equalToSuperview().inset(55)
            make.height.equalTo(24)
        }

        view.addSubview(sizeTitleLabel)
        sizeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(39)
            make.top.equalTo(stiffnessTitleLabel.snp.bottom).offset(viewHeight*0.167)
        }
        
        view.addSubview(sizeSelectionCollectionView)
        sizeSelectionCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(sizeTitleLabel.snp.trailing).offset(51)
            make.centerY.equalTo(sizeTitleLabel.snp.top)
            make.trailing.equalToSuperview().inset(79)
            make.height.equalTo(46)
        }
    }
}
