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
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

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
        let didEnterBirthDate = PublishRelay<String>()
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
        let selectGender = PublishRelay<GenderType>()
        let showDetailView = PublishRelay<DocumentType>()
        let selectAllConditions = PublishRelay<Bool>()
        let activateNextButton = BehaviorRelay<Bool>(value: false)
        let showError = PublishRelay<Error>()
    }
    
    public struct State {
        let selectedConditions = BehaviorRelay<Set<AgreementCondition>>(value: [])
        let gender = BehaviorRelay<GenderType?>(value: nil)
        let birthDate = BehaviorRelay<String?>(value: nil)
    }
    
    public let input = Input()
    public let output = Output()
    private let state = State()
    
    @Inject(LoginDIContainer.shared) private var signupUseCase: SignupUseCase
    @Inject(SharedDIContainer.shared) private var bundleResourceUseCase: BundleResourceUseCase
    
    // FIXME: 디폴트 캐릭터 지정하기 위한 UseCase - 서버에서 디폴트 캐릭터 설정된 상태로 받아올 경우 삭제
    @Inject(SharedDIContainer.shared) private var profileCharacterUseCase: ProfileCharacterUseCase

    private weak var coordinator: LoginCoordinator?
    private let authInfo: OAuthTokenInfo
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?, authInfo: OAuthTokenInfo) {
        self.coordinator = coordinator
        self.authInfo = authInfo
        bind()
    }
    
    private func bind() {
        guard let coordinator = self.coordinator else { return }
        
        // FIXME: 디폴트 캐릭터 지정하는 코드 - 서버에서 디폴트 캐릭터 설정된 상태로 받아올 경우 삭제
        input.didTapNextButton
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, _ in
                self.profileCharacterUseCase.updateProfileCharacter(to: ProfileCharacter(color: .brown, shape: .good))
            }
            .bind { _ in }
            .disposed(by: disposeBag)
        
        signupUseCase.fetchSelectableConditions()
            .withUnretained(self)
            .map { `self`, entities in
                entities.map {
                    let cellViewModel = ConditionSelectionCellViewModel(entity: $0)
                    self.bindCellViewModelToParent(
                        cellViewModel,
                        numberOfConditions: entities.count,
                        disposeBag: self.disposeBag
                    )
                    
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
        
        let birthDateInput = input.didEnterBirthDate.share()
        
        birthDateInput
            .bind(to: state.birthDate)
            .disposed(by: disposeBag)
        
        birthDateInput
            .withUnretained(self)
            .flatMap { `self`, input in
                self.signupUseCase.isBirthdayInputValid(input)
            }
            .map { $0.status }
            .bind(to: output.birthdayTextFieldStatus)
            .disposed(by: disposeBag)
            
        input.didTapSelectAllCondition
            .withLatestFrom(output.conditionSelectionCellViewModels) {
                (isSelected: !$0, cellViewModels: $1)
            }
            .bind(onNext: { [weak self] isSelected, cellViewModels in
                self?.output.selectAllConditions.accept(isSelected)
                
                cellViewModels.forEach {
                    $0.output.selectCheckBox.accept(isSelected)
                }
            })
            .disposed(by: disposeBag)
        
        let genderInput = input.didTapGenderButton
            .map { GenderType.allCases[$0] }
            .share()
        
        genderInput
            .bind(to: output.selectGender)
            .disposed(by: disposeBag)
        
        genderInput
            .bind(to: state.gender)
            .disposed(by: disposeBag)

        input.didTapLeftBarbutton
            .bind(onNext: { _ in
                coordinator.coordinate(by: .popCurrentScene)
            })
            .disposed(by: disposeBag)
        
        let signupInput = Observable
            .combineLatest(
                input.didEnterNickname,
                state.birthDate,
                state.gender,
                state.selectedConditions
            )
            .map { (nickname: $0, birthDate: $1, gender: $2, conditions: $3) }
            .share()
        
        signupInput
            .withUnretained(self)
            .flatMap { `self`, signupInfo in
                Observable.combineLatest(
                    self.signupUseCase.isNicknameInputValid(signupInfo.nickname).map { $0.isValid },
                    self.signupUseCase.isAllEsssentialConditionsSelected(signupInfo.conditions),
                    self.signupUseCase.isBirthdayInputValid(signupInfo.birthDate ?? "").map { $0.status != .impossible }
                )
            }
            .map { $0 && $1 && $2 }
            .bind(to: output.activateNextButton)
            .disposed(by: disposeBag)
        
        let requestSignup = input.didTapNextButton
            .withLatestFrom(signupInput)
            .compactMap { [weak self] nickname, birthDate, gender, conditions -> SignupInput? in
                guard let oAuthAccessToekn = self?.authInfo.accessToken,
                      let provider = self?.authInfo.loginType else { return nil }
                
                let birthDate = self?.signupUseCase.createFormattedDateString(with: birthDate)

                return SignupInput(
                    nickname: nickname,
                    birthDate: birthDate,
                    gender: gender,
                    conditions: conditions,
                    oAuthAccessToken: oAuthAccessToekn,
                    provider: provider
                )
            }
            .withUnretained(self)
            .flatMapLatestMaterialized { `self`, signupInput in
                self.signupUseCase.requestSignup(signupInput)
            }
            .share()
        
        requestSignup
            .compactMap { $0.element }
            .bind(onNext: { isSuccess in
                guard isSuccess else { return }
                coordinator.coordinate(by: .finishLoginFlow)
            })
            .disposed(by: disposeBag)
        
        requestSignup
            .compactMap { $0.error }
            .bind(to: output.showError)
            .disposed(by: disposeBag)
    }
    
    private func bindCellViewModelToParent(
        _ cellViewModel: ConditionSelectionCellViewModel,
        numberOfConditions: Int,
        disposeBag: DisposeBag
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
                coordinator?.coordinate(by: .showDetailForm(title: title, detailText: detailText))
            })
            .disposed(by: disposeBag)

        cellViewModel.input.didTapCheckBox
            .withLatestFrom(cellViewModel.output.selectCheckBox)
            .map { !$0 }
            .bind(to: cellViewModel.output.selectCheckBox)
            .disposed(by: self.disposeBag)
        
        let selectedConditions = cellViewModel.output.selectCheckBox
            .withLatestFrom(state.selectedConditions) { ($0, $1) }
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
                let isEveryConditionsSelected = selectedConditions.count == numberOfConditions
                self?.output.selectAllConditions.accept(isEveryConditionsSelected)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}
