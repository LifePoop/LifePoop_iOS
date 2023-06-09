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
    
    private let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: ImageAsset.expandLeft.original)

    private let scrollView = UIScrollView()
    
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
    
    private let genderSelectionCollectionViewDelegate = GenderSelectionCollectionViewDelegate()
    private lazy var genderSelectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 7

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            GenderSelectionCell.self,
            forCellWithReuseIdentifier: GenderSelectionCell.identifier
        )
        collectionView.delegate = genderSelectionCollectionViewDelegate
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        return collectionView
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
    
    public var viewModel: SignupViewModel?
    private var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHandlingTouchEvent()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nicknameTextField.becomeFirstResponder()
    }
    
    public func bindInput(to viewModel: SignupViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: input.didTapNextButton)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text
            .bind(to: input.didEnterTextValue)
            .disposed(by: disposeBag)
        
        leftBarButton.rx.tap
            .bind(to: input.didTapLeftBarbutton)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: SignupViewModel) {
        let output = viewModel.output
        
        output.textFieldStatus
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
        
        output.selectableGenderConditions
            .bind(to: genderSelectionCollectionView.rx.items(
                cellIdentifier: GenderSelectionCell.identifier,
                cellType: GenderSelectionCell.self)
            ) { _, gender, cell in
                
                cell.configure(with: gender)
            }
            .disposed(by: disposeBag)
        
        output.activateNextButton
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
  
        
        output.selectAllConditions
            .withUnretained(self)
            .bind(onNext: { owner, isSelected in
                if isSelected {
                    owner.conditionSelectionCollectionView.selectAllItems()
                } else {
                    owner.conditionSelectionCollectionView.deselectAllItems()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Configuration

    public override func configureUI() {
        super.configureUI()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = leftBarButton
        view.backgroundColor = .systemBackground
    }
    
    func configureHandlingTouchEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
         view.endEditing(true) // Hide the keyboard
     }
    
    // MARK: - UI Layout
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        disableScrollingIfNeeded()
    }
    
    // TODO: contentSize 다시 도출해서 정확한 연산으로 변경
    private func disableScrollingIfNeeded() {
        let enableScrolling = view.frame.height <= 670
        scrollView.isScrollEnabled = enableScrolling
    }
    
    public override func layoutUI() {
        super.layoutUI()
        
        let frameWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let frameHeight = view.safeAreaLayoutGuide.layoutFrame.height

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(nicknameTextField)
        containerView.addSubview(birthdayTextField)
        containerView.addSubview(genderSelectTitleLabel)
        containerView.addSubview(genderSelectionCollectionView)
        containerView.addSubview(selectAllConditionView)
        containerView.addSubview(conditionSelectionCollectionView)
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(frameWidth)
            make.height.equalTo(frameHeight+15)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        birthdayTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        genderSelectTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayTextField.snp.bottom).offset(13)
            make.leading.equalToSuperview().inset(frameWidth*0.06)
        }
        
        genderSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genderSelectTitleLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.height.equalTo(50)
        }
        
        selectAllConditionView.snp.makeConstraints { make in
            make.top.equalTo(genderSelectionCollectionView.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
        }
        
        conditionSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectAllConditionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.height.equalTo(173)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }
}

extension UICollectionView {
    
    func selectAllItems() {
        let indexPathsForVisibleItems = self.indexPathsForVisibleItems
        for indexPath in indexPathsForVisibleItems {
            self.selectItem(
                at: indexPath, animated: false, scrollPosition: .centeredHorizontally
            )
        }
    }
    
    func deselectAllItems() {
        let indexPaths = self.indexPathsForSelectedItems ?? []
        for indexPath in indexPaths {
            self.deselectItem(at: indexPath, animated: false)
        }
    }
}
