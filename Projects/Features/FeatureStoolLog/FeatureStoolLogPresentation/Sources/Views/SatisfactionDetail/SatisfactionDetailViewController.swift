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
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
    
    private lazy var sizeSelectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 38
        layout.itemSize = .init(width: 35, height: 52)
        
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
        button.roundCorners(radius: 12)
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
        
        colorSelectCollectionView.rx.modelSelected(StoolColor.self)
            .bind(to: input.didSelectColor)
            .disposed(by: disposeBag)
        
        stoolShapeSelectCollectionView.rx.modelSelected(ColoredStoolShape.self)
            .map { $0.shape }
            .bind(to: input.didSelectShape)
            .disposed(by: disposeBag)
        
        sizeSelectionCollectionView.rx.modelSelected(StoolSize.self)
            .bind(to: input.didSelectSize)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .map { IndexPath(item: 0, section: 0) }
            .withUnretained(self)
            .bind(onNext: { `self`, indexPath in
                let collectionViews = [
                    self.colorSelectCollectionView,
                    self.stoolShapeSelectCollectionView,
                    self.sizeSelectionCollectionView
                ]
                
                collectionViews.forEach {
                    $0.selectItemManually(indexPath: indexPath)
                }
            })
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
        
        output.selectableSizes
            .bind(to: sizeSelectionCollectionView.rx.items(
                cellIdentifier: SizeSelectionCell.identifier,
                cellType: SizeSelectionCell.self)
            ) { _, size, cell in
                cell.configure(selectableSize: size)
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
        
        let viewHeight = view.frame.height
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(46)
            make.height.equalTo(54)
        }
        
        view.addSubview(stoolShapeTitleLabel)
        stoolShapeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalToSuperview().offset(viewHeight*0.38)
        }
        
        view.addSubview(stoolShapeSelectCollectionView)
        stoolShapeSelectCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(stoolShapeTitleLabel.snp.trailing).offset(15)
            make.centerY.equalTo(stoolShapeTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(27)
            make.height.equalTo(34)
        }

        view.addSubview(colorTitleLabel)
        colorTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.bottom.equalTo(stoolShapeTitleLabel.snp.top).offset(-viewHeight*0.167)
        }
        
        view.addSubview(colorSelectCollectionView)
        colorSelectCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(colorTitleLabel.snp.centerY)
            make.leading.equalTo(colorTitleLabel.snp.trailing).offset(29)
            make.trailing.equalToSuperview().inset(44)
            make.height.equalTo(30)
        }
        
        view.addSubview(sizeTitleLabel)
        sizeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(39)
            make.top.equalTo(stoolShapeTitleLabel.snp.bottom).offset(viewHeight*0.167)
        }
        
        view.addSubview(sizeSelectionCollectionView)
        sizeSelectionCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(sizeTitleLabel.snp.trailing).offset(51)
            make.centerY.equalTo(sizeTitleLabel.snp.top)
            make.trailing.equalToSuperview().inset(79)
            make.height.equalTo(52)
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
