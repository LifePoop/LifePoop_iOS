//
//  SignupViewController.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/17.
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

public final class SignupViewController: LifePoopViewController, ViewType {
        
    private let scrollView = UIScrollView()
    
    private var containerViewHeightConstraint: Constraint?
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let nicknameTextField: ConditionalTextField = {
        let textField = ConditionalTextField()
        textField.title = "닉네임을 설정해주세요"
        textField.placeholder = "닉네임 입력하기"
        textField.status = .none(text: "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다.")
        return textField
    }()
    
    private let birthdayTextField: ConditionalTextField = {
        let textField = ConditionalTextField()
        textField.title = "생년월일을 입력해주세요"
        textField.placeholder = "예) 990101"
        textField.status = .none(text: "")
        return textField
    }()
    
    private let genderSelectTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "성별을 선택해주세요"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = ColorAsset.pooBlack.color
        return label
    }()
    
    private let genderSelectionButtons: [TextSelectionButton] = GenderType.allCases.map {
        TextSelectionButton(
            index: $0.index,
            title: $0.description,
            backgroundColor: .init(
                selected: ColorAsset.primary.color,
                deselected: ColorAsset.gray300.color
            ),
            titleColor: .init(
                selected: ColorAsset.white.color,
                deselected: ColorAsset.gray800.color
            )
        )
    }
    
    private lazy var genderSelectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: genderSelectionButtons)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let selectAllConditionView: ConditionSelectionView = ConditionSelectionView()
    
    private let conditionSelectionCollectionViewDelegate = ConditionSelectionCollectionViewDelegate()
    private lazy var conditionSelectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ConditionSelectionCell.self,
            forCellWithReuseIdentifier: ConditionSelectionCell.identifier
        )
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = conditionSelectionCollectionViewDelegate
        collectionView.isScrollEnabled = false
        
        collectionView.backgroundColor = ColorAsset.gray200.color
        collectionView.roundCorners(
            corners: [.topRight, .topLeft, .bottomRight, .bottomLeft],
            radius: 12
        )
        
        return collectionView
    }()
    
    private let nextButton = LifePoopButton(title: "다음")
    
    private var sumOfVerticalMargins: CGFloat = .zero
    
    public var viewModel: SignupViewModel?
    private var disposeBag = DisposeBag()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nicknameTextField.becomeFirstResponder()
    }
    
    func configureHandlingTouchEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true) // Hide the keyboard
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let nextButtonHeight = nextButton.frame.height
        let subViewsHeight = containerView.subviews.reduce(0) { $0 + $1.bounds.height }
        let totalContentsHeight = subViewsHeight + sumOfVerticalMargins + nextButtonHeight
        let properContentsHeight = totalContentsHeight * 1.05
        
        let enableScrollView = safeAreaHeight <= properContentsHeight
        if enableScrollView {
            containerViewHeightConstraint?.update(offset: properContentsHeight)
        }
        
        scrollView.isScrollEnabled = enableScrollView
    }
    
    public func bindInput(to viewModel: SignupViewModel) {
        let input = viewModel.input
        
        nextButton.rx.tap
            .bind(to: input.didTapNextButton)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text
            .skip(1)
            .bind(to: input.didEnterNickname)
            .disposed(by: disposeBag)
        
        birthdayTextField.rx.text
            .skip(1)
            .bind(to: input.didEnterBirthday)
            .disposed(by: disposeBag)
        
        selectAllConditionView.rx.check
            .bind(to: input.didTapSelectAllCondition)
            .disposed(by: disposeBag)
        
        Observable.merge(
            genderSelectionButtons.map { button in
                button.rx.tap.map { button.index }
            }
        )
        .bind(to: input.didTapGenderButton)
        .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SignupViewModel) {
        let output = viewModel.output
        
        output.nicknameTextFieldStatus
            .map {
                switch $0 {
                case .none(let text):
                    return ConditionalTextField.TextFieldStatus.none(text: text)
                case .possible(let text):
                    return ConditionalTextField.TextFieldStatus.possible(text: text)
                case .impossible(let text):
                    return ConditionalTextField.TextFieldStatus.impossible(text: text)
                }
            }
            .bind(to: nicknameTextField.rx.status)
            .disposed(by: disposeBag)
        
        output.birthdayTextFieldStatus
            .map {
                switch $0 {
                case .none(let text):
                    return ConditionalTextField.TextFieldStatus.none(text: text)
                case .possible(let text):
                    return ConditionalTextField.TextFieldStatus.possible(text: text)
                case .impossible(let text):
                    return ConditionalTextField.TextFieldStatus.impossible(text: text)
                }
            }
            .bind(to: birthdayTextField.rx.status)
            .disposed(by: disposeBag)
        
        output.activateNextButton
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.conditionSelectionCellViewModels
            .bind(to: conditionSelectionCollectionView.rx.items(
                cellIdentifier: ConditionSelectionCell.identifier,
                cellType: ConditionSelectionCell.self)
            ) { index, cellViewModel, cell in
                
                cell.bind(to: cellViewModel, withIndexOf: index)
            }
            .disposed(by: disposeBag)
        
        output.shouldSelectAllConditions
            .bind(to: selectAllConditionView.rx.isChecked)
            .disposed(by: disposeBag)
        
        output.shouldSelectGender
            .map { $0.index }
            .withUnretained(self)
            .bind(onNext: { `self`, targetIndex in
                self.genderSelectionButtons.forEach {
                    let isSelected = targetIndex == $0.index
                    $0.rx.isSelected.onNext(isSelected)
                }
            })
            .disposed(by: disposeBag)
        
        output.selectAllOptionConfig
            .withUnretained(self)
            .bind(onNext: { `self`, entity in
                self.selectAllConditionView.configure(with: entity)
            })
            .disposed(by: disposeBag)
    }
    
    public override func configureUI() {
        super.configureUI()

        configureHandlingTouchEvent()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
        
    public override func layoutUI() {
        let frameWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let frameHeight = view.safeAreaLayoutGuide.layoutFrame.height
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(nicknameTextField)
        containerView.addSubview(birthdayTextField)
        containerView.addSubview(genderSelectTitleLabel)
        containerView.addSubview(genderSelectionStackView)
        containerView.addSubview(selectAllConditionView)
        containerView.addSubview(conditionSelectionCollectionView)
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(frameWidth)
            containerViewHeightConstraint = make.height.equalTo(frameHeight).constraint
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            sumOfVerticalMargins += 28
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        birthdayTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            sumOfVerticalMargins += 30
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        genderSelectTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayTextField.snp.bottom).offset(32)
            sumOfVerticalMargins += 32
            
            make.leading.equalToSuperview().inset(frameWidth*0.06)
        }
        
        genderSelectionStackView.snp.makeConstraints { make in
            make.top.equalTo(genderSelectTitleLabel.snp.bottom).offset(13)
            sumOfVerticalMargins += 13
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.height.equalTo(50)
        }
        
        genderSelectionStackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(1/3.2)
                make.height.equalToSuperview()
            }
        }
        
        selectAllConditionView.snp.makeConstraints { make in
            make.top.equalTo(genderSelectionStackView.snp.bottom).offset(38)
            sumOfVerticalMargins += 38
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        conditionSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectAllConditionView.snp.bottom).offset(10)
            sumOfVerticalMargins += 10
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.height.equalTo(173)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            sumOfVerticalMargins += 12
        }
    }
}
