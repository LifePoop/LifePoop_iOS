//
//  NicknameViewController.swift
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
import Utils

public final class NicknameViewController: UIViewController, ViewType {
    
    private let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: ImageAsset.expandLeft.original)

    private let nicknameTextField: ConditionalTextField = {
        let textField = ConditionalTextField()
        textField.title = "닉네임을 설정해주세요"
        textField.placeholder = "닉네임 입력하기"
        textField.status = .none(text: "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다.")
        return textField
    }()
    
    private lazy var conditionSelectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ConditionSelectionCell.self,
            forCellWithReuseIdentifier: ConditionSelectionCell.identifier
        )
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        return collectionView
    }()
    
    private let nextButton = LifePoopButton(title: "다음")
    
    public var viewModel: NicknameViewModel?
    private var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        configureUI()
        layoutUI()
    }
    
    public func bindInput(to viewModel: NicknameViewModel) {
        let input = viewModel.input
        
        nextButton.rx.tap
            .bind(to: input.didTapNextButton)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text
            .bind(to: input.nicknameInput)
            .disposed(by: disposeBag)
        
        conditionSelectionCollectionView.rx.modelSelected(SelectableConfirmationCondition.self)
            .bind(to: input.didSelectConfirmCondition)
            .disposed(by: disposeBag)
        
        conditionSelectionCollectionView.rx.modelDeselected(SelectableConfirmationCondition.self)
            .bind(to: input.didDeselectConfirmCondition)
            .disposed(by: disposeBag)
        
        leftBarButton.rx.tap
            .bind(to: input.didTapLeftBarbutton)
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    public func bindOutput(from viewModel: NicknameViewModel) {
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
        
        output.activateNextButton
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.selectableConditions
            .bind(to: conditionSelectionCollectionView.rx.items(
                cellIdentifier: ConditionSelectionCell.identifier,
                cellType: ConditionSelectionCell.self)
            ) { _, selectableCondition, cell in
                
                cell.configure(with: selectableCondition)
            }
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
}

// MARK: - UI Configuration

private extension NicknameViewController {
    
    func configureUI() {
        
        navigationItem.leftBarButtonItem = leftBarButton
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension NicknameViewController {
    func layoutUI() {
        let frameHeight = view.frame.height
        let frameWidth = view.frame.width

        view.addSubview(nicknameTextField)
        view.addSubview(conditionSelectionCollectionView)
        view.addSubview(nextButton)
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.height.equalTo(120)
        }
        
        conditionSelectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(frameWidth*0.06)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }
}

extension NicknameViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        
        let isVeryTop = indexPath.item == 0
        let cellHeight: CGFloat = 22
        let bottomMargin: CGFloat = isVeryTop ? 25 : 13
        
        return .init(width: collectionView.bounds.width, height: cellHeight + bottomMargin)
    }
}

extension Reactive where Base == ConditionalTextField {
    
    var text: ControlProperty<String> {
        base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { $0.text ?? "" },
            setter: { insertField, text in
                insertField.text = text
            }
        )
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
