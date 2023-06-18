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
import DesignSystemReactive
import Utils

public final class SatisfactionDetailViewController: LifePoopViewController, ViewType {
        
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "색깔"
        return label
    }()
    
    private let stoolShapeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "모양"
        return label
    }()
    
    private let sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "크기"
        return label
    }()
    
    private let colorSelectCollectionViewDelegate = SelectCollectionViewDelegate()
    private lazy var colorSelectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 23
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorSelectionCell.self, forCellWithReuseIdentifier: ColorSelectionCell.identifier)
        collectionView.delegate = colorSelectCollectionViewDelegate
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let shapeSelectCollectionViewDelegate = SelectCollectionViewDelegate()
    private lazy var stoolShapeSelectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ShapeSelectionCell.self,
            forCellWithReuseIdentifier: ShapeSelectionCell.identifier
        )
        collectionView.delegate = shapeSelectCollectionViewDelegate
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let sizeSelectionSegmentControl = LifePoopSegmentControl()
    
    private let completeButton = LifePoopButton(title: "완료")
    
    public var viewModel: SatisfactionDetailViewModel?
    private var disposeBag = DisposeBag()
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addSubViews()
    }
    
    public func bindInput(to viewModel: SatisfactionDetailViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind(to: input.didTapCompleteButton)
            .disposed(by: disposeBag)
        
        colorSelectCollectionView.rx.modelSelected(StoolColor.self)
            .bind(to: input.didSelectColor)
            .disposed(by: disposeBag)
        
        stoolShapeSelectCollectionView.rx.modelSelected(ColoredStoolShape.self)
            .map { $0.shape }
            .bind(to: input.didSelectShape)
            .disposed(by: disposeBag)
        
        sizeSelectionSegmentControl.rx.selectedSegmentIndex
            .compactMap { $0 }
            .map { StoolSize.allCases[$0] }
            .bind(to: input.didSelectSize)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SatisfactionDetailViewModel) {
        let output = viewModel.output
        
        output.titleText
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.sizeSelectionSegmentTitles
            .bind(onNext: sizeSelectionSegmentControl.setTitles(_:))
            .disposed(by: disposeBag)
        
        output.selectableColors
            .bind(to: colorSelectCollectionView.rx.items(
                cellIdentifier: ColorSelectionCell.identifier,
                cellType: ColorSelectionCell.self)
            ) { _, color, cell in
                cell.configure(selectableColor: color)
            }
            .disposed(by: disposeBag)
        
        output.selectableShapes
            .bind(to: stoolShapeSelectCollectionView.rx.items(
                cellIdentifier: ShapeSelectionCell.identifier,
                cellType: ShapeSelectionCell.self)
            ) { [weak self] index, entity, cell in
                cell.configure(stoolShapeSelection: entity.shape, colorOf: entity.color)
                
                guard entity.isSelected,
                      let collectionView = self?.stoolShapeSelectCollectionView
                else { return }

                let indexPath = IndexPath(item: index, section: 0)
                collectionView.selectItemManually(indexPath: indexPath)
            }
            .disposed(by: disposeBag)
        
        output.enableCompleButton
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

private extension SatisfactionDetailViewController {
    
    func addSubViews() {
    
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(54)
        }
        
        view.addSubview(colorTitleLabel)
        colorTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        view.addSubview(colorSelectCollectionView)
        colorSelectCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(colorTitleLabel.snp.centerY)
            make.leading.equalTo(colorTitleLabel.snp.trailing).offset(29)
            make.trailing.equalToSuperview().inset(44)
            make.height.equalTo(30)
        }
        
        view.addSubview(stoolShapeTitleLabel)
        stoolShapeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalTo(colorTitleLabel.snp.bottom).offset(59)
        }
        
        view.addSubview(stoolShapeSelectCollectionView)
        stoolShapeSelectCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(stoolShapeTitleLabel.snp.trailing).offset(15)
            make.centerY.equalTo(stoolShapeTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(27)
            make.height.equalTo(34)
        }

        view.addSubview(sizeTitleLabel)
        sizeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.width.equalTo(28)
            make.top.equalTo(stoolShapeTitleLabel.snp.bottom).offset(59)
        }
        
        view.addSubview(sizeSelectionSegmentControl)
        sizeSelectionSegmentControl.snp.makeConstraints { make in
            make.centerY.equalTo(sizeTitleLabel.snp.centerY)
            make.leading.equalTo(sizeTitleLabel.snp.trailing).offset(27)
            make.trailing.equalToSuperview().inset(39)
            make.height.equalTo(44)
        }
    }
}

extension UICollectionView {
    
    func selectItemManually(indexPath: IndexPath) {
        selectItem(
            at: indexPath, animated: false,
            scrollPosition: .centeredHorizontally
        )
        
        cellForItem(at: indexPath)?.isSelected = true
        delegate?.collectionView?(self, didSelectItemAt: indexPath)
    }
}
