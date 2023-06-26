//
//  SignupViewModel.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureLoginCoordinatorInterface
import FeatureLoginDIContainer
import FeatureLoginUseCase
import SharedDIContainer
import SharedUseCase
import Utils

public struct SignupInfo {
    
    let nickname: String
    let birthday: String
    let gender: GenderType?
    let conditions: Set<AgreementCondition>
}

public final class SignupViewModel: ViewModelType {

    enum DetailViewType {
        case termsOfService
        case privacyPolicy
    }
    
    enum TextFieldStatus {
        case possible(text: String)
        case impossible(text: String)
        case none(text: String)
    }
    
    public struct Input {
        let didTapNextButton = PublishRelay<Void>()
        let didEnterNickname = PublishRelay<String>()
        let didEnterBirthday = PublishRelay<String>()
        let didTapSelectAllCondition = PublishRelay<Bool>()
        let didSelectConfirmCondition = PublishRelay<AgreementCondition>()
        let didDeselectConfirmCondition = PublishRelay<AgreementCondition>()
        let didTapGenderButton = PublishRelay<Int>()
        let didTapLeftBarbutton = PublishRelay<Void>()
        let didTapDetailViewButton = PublishRelay<DetailViewType>()
    }
    
    public struct Output {
        let conditionSelectionCellViewModels = BehaviorRelay<[ConditionSelectionCellViewModel]>(value: [])
        let nicknameTextFieldStatus = BehaviorRelay<NicknameTextInput.Status>(value: .`default`)
        let birthdayTextFieldStatus = BehaviorRelay<BirthdayTextInput.Status>(value: .`default`)
        let shouldCheckCondition = PublishRelay<Int>()
        let selectAllOptionConfig = Observable.just(AgreementCondition(
            descriptionText: LocalizableString.agreeToAllTerms,
            descriptionTextSize: .large
        ))
        let shouldSelectGender = PublishRelay<GenderType>()
        let shouldShowDetailView = PublishRelay<DocumentType>()
        let shouldSelectAllConditions = PublishRelay<Bool>()
        let activateNextButton = BehaviorRelay<Bool>(value: false)
    }
    
    public struct State {
        let selectedConditions = BehaviorRelay<Set<AgreementCondition>>(value: [])
    }
    
    public let input = Input()
    public let output = Output()
    private let state = State()
    
    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase
    @Inject(LoginDIContainer.shared) private var signupUseCase: SignupUseCase
    @Inject(SharedDIContainer.shared) private var bundleResourceUseCase: BundleResourceUseCase

    private weak var coordinator: LoginCoordinator?
    private let authInfo: UserAuthInfoEntity
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?, authInfo: UserAuthInfoEntity) {
        self.coordinator = coordinator
        self.authInfo = authInfo
        bind()
    }
    
    private func bind() {
        guard let coordinator = self.coordinator else { return }
        
        signupUseCase.fetchSelectableConditions()
            .withUnretained(self)
            .map { `self`, entities in
                entities.map {
                    let cellViewModel = ConditionSelectionCellViewModel(entity: $0)
                    self.bindCellViewModelToParent(cellViewModel, with: self.disposeBag)
                    
                    return cellViewModel
                }
            }
            .bind(to: output.conditionSelectionCellViewModels)
            .disposed(by: disposeBag)
        
        let nicknameInputStatus = input.didEnterNickname
            .withUnretained(self)
            .flatMap { `self`, input in
                self.signupUseCase.isNicknameInputValid(input)
            }
            .share()
        
        nicknameInputStatus
            .map { $0.status }
            .bind(to: output.nicknameTextFieldStatus)
            .disposed(by: disposeBag)
        
        let birthdayInputStatus = input.didEnterBirthday
            .withUnretained(self)
            .flatMap { `self`, input in
                self.signupUseCase.isBirthdayInputValid(input)
            }
            .share()
  
        birthdayInputStatus
            .map { $0.status }
            .bind(to: output.birthdayTextFieldStatus)
            .disposed(by: disposeBag)
            
        input.didTapSelectAllCondition
            .withLatestFrom(output.conditionSelectionCellViewModels) {
                (isSelected: !$0, cellViewModels: $1)
            }
            .bind(onNext: { [weak self] isSelected, cellViewModels in
                self?.output.shouldSelectAllConditions.accept(isSelected)
                
                cellViewModels.forEach {
                    $0.output.shouldSelectCheckBox.accept(isSelected)
                }
            })
            .disposed(by: disposeBag)
        
        input.didTapGenderButton
            .map { GenderType.allCases[$0] }
            .bind(to: output.shouldSelectGender)
            .disposed(by: disposeBag)

        input.didTapLeftBarbutton
            .bind(onNext: { _ in
                coordinator.coordinate(by: .shouldPopCurrentScene)
            })
            .disposed(by: disposeBag)
        
        let signupInfo = Observable
            .combineLatest(
                input.didEnterNickname,
                input.didEnterBirthday,
                output.shouldSelectGender,
                state.selectedConditions
            )
            .map { SignupInfo(nickname: $0, birthday: $1, gender: $2, conditions: $3) }
            .share()
        
        signupInfo
            .withUnretained(self)
            .flatMap { `self`, signupInfo in
                Observable.combineLatest(
                    self.signupUseCase.isNicknameInputValid(signupInfo.nickname).map { $0.isValid },
                    self.signupUseCase.isBirthdayInputValid(signupInfo.birthday).map { $0.isValid },
                    self.signupUseCase.isAllEsssentialConditionsSelected(signupInfo.conditions)
                )
            }
            .map { $0 && $1 && $2 }
            .bind(to: output.activateNextButton)
            .disposed(by: disposeBag)
        
        input.didTapNextButton
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(signupInfo)
            .withUnretained(self)
            .flatMapLatestCompletableMaterialized { `self`, signupInfo in
                let userInfo = UserInfoEntity(nickname: signupInfo.nickname, authInfo: self.authInfo)
                return self.loginUseCase.saveUserInfo(userInfo)
            }
            .filter { $0.isCompleted }
            .bind(onNext: { _ in
                coordinator.coordinate(by: .shouldFinishLoginFlow)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCellViewModelToParent(
        _ cellViewModel: ConditionSelectionCellViewModel,
        with disposeBag: DisposeBag
    ) {
        
        cellViewModel.input.didTapDetailButton
            .compactMap { index -> DocumentType? in
                switch index {
                case 1: return .termsOfService
                case 2: return .privacyPolicy
                default: return nil
                }
            }
            .withUnretained(self)
            .flatMapLatest { `self`, documentType in
                Observable.zip(
                    Observable.just(documentType.title),
                    self.bundleResourceUseCase.readText(from: documentType.textFile)
                )
            }
            .bind(onNext: { [weak self] title, detailText in
                let coordinator = self?.coordinator
                coordinator?.coordinate(by: .shouldShowDetailForm(title: title, detailText: detailText))
            })
            .disposed(by: disposeBag)

        cellViewModel.input.didTapCheckBox
            .withLatestFrom(cellViewModel.output.shouldSelectCheckBox)
            .map { !$0 }
            .bind(to: cellViewModel.output.shouldSelectCheckBox)
            .disposed(by: self.disposeBag)
        
        let selectedConditions = cellViewModel.output.shouldSelectCheckBox
            .withLatestFrom(state.selectedConditions) { ($0, $1)}
            .map { shouldSelect, selectedConditions in
                let condition = cellViewModel.entity
                var selectedConditions = selectedConditions
                
                if shouldSelect {
                    selectedConditions.insert(condition)
                } else {
                    selectedConditions.remove(condition)
                }
                
                return selectedConditions
            }
            .share()
        
        selectedConditions
            .bind(to: state.selectedConditions)
            .disposed(by: disposeBag)
        
        selectedConditions
            .bind(onNext: { [weak self] selectedConditions in
                let isEveryConditionsSelected = selectedConditions.count == 4
                self?.output.shouldSelectAllConditions.accept(isEveryConditionsSelected)
            })
            .disposed(by: disposeBag)
    }
}
