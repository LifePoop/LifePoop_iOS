//
//  ProfileCharacterEditViewController.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

import CoreEntity
import DesignSystem
import Utils

public final class ProfileCharacterEditViewController: LifePoopViewController, ViewType {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캐릭터를 설정해주세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "색깔"
        return label
    }()
    
    private let shapeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorAsset.black.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "모양"
        return label
    }()
    
    private let colorSelectionButtons = StoolColor.allCases.map {
        ImageSelectionButton(selectedImage: $0.selectedImage, deselectedImage: $0.deselectedImage, index: $0.index)
    }
    
    private lazy var colorSelectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: colorSelectionButtons)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let shapeSelectionButtons = StoolShape.allCases.map {
        ImageSelectionButton(deselectedImage: $0.deselectedImage, index: $0.index)
    }
    
    private lazy var shapeSelectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: shapeSelectionButtons)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public var viewModel: ProfileCharacterEditViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - ViewModel Binding
    
    public func bindInput(to viewModel: ProfileCharacterEditViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        Observable.merge(colorSelectionButtons.map { button in
            button.rx.tap.map { button.index }
        })
        .bind(to: input.profileCharacterColorDidSelectAt)
        .disposed(by: disposeBag)
        
        Observable.merge(shapeSelectionButtons.map { button in
            button.rx.tap.map { button.index }
        })
        .bind(to: input.profileCharacterShapeDidSelectAt)
        .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: ProfileCharacterEditViewModel) {
        let output = viewModel.output
        
        output.selectProfileCharacterColor
            .asSignal()
            .map { $0.index }
            .emit(onNext: colorSelectionButtons.selectButtonOnly(at:))
            .disposed(by: disposeBag)
        
        output.selectProfileCharacterCharacter
            .asSignal()
            .map { (index: $0.shape.index, image: $0.image) }
            .do { [weak self] in
                let (index, image) = $0
                self?.shapeSelectionButtons[index].setSelectedImage(image)
            }
            .map { $0.index }
            .emit(onNext: shapeSelectionButtons.selectButtonOnly(at:))
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    
    public override func layoutUI() {
        super.layoutUI()
        view.addSubview(titleLabel)
        view.addSubview(colorTitleLabel)
        view.addSubview(colorSelectionStackView)
        view.addSubview(shapeTitleLabel)
        view.addSubview(shapeSelectionStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-6)
            make.centerX.equalToSuperview()
        }
        
        colorTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.56)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        colorSelectionStackView.snp.makeConstraints { make in
            make.leading.equalTo(colorTitleLabel.snp.trailing).offset(35)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-46)
            make.centerY.equalTo(colorTitleLabel)
        }
        
        shapeTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        shapeSelectionStackView.snp.makeConstraints { make in
            make.leading.equalTo(shapeTitleLabel.snp.trailing).offset(49.5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-60.5)
            make.centerY.equalTo(shapeTitleLabel)
        }
    }
}
