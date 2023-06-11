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
>>>>>>> develop:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/NicknameScene/NicknameViewModel.swift

    public struct Input {
        let didTapNextButton = PublishRelay<Void>()
        let didEnterTextValue = PublishRelay<String>()
        let didTapSelectAllCondition = PublishRelay<Bool>()
        let didSelectConfirmCondition = PublishRelay<AgreementCondition>()
        let didDeselectConfirmCondition = PublishRelay<AgreementCondition>()
        let didTapLeftBarbutton = PublishRelay<Void>()
        let didTapDetailViewButton = PublishRelay<DetailViewType>()
        let viewDidLoad = PublishRelay<Void>()
    }
    
    public struct Output {
        let conditionSelectionCellViewModels = BehaviorRelay<[ConditionSelectionCellViewModel]>(value: [])
        let nicknameTextFieldStatus = BehaviorRelay<NicknameInputStatus.Status>(value:
                .none(description: "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다.")
        )
        let birthdayTextFieldStatus = BehaviorRelay<NicknameInputStatus.Status>(value: .none(description: ""))
        let shouldCheckCondition = PublishRelay<Int>()
        let selectAllOptionConfig = Observable.just(AgreementCondition(
            descriptionText: "전체동의",
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
        
        input.viewDidLoad
            .map { ["여성", "남성", "기타"] }
            .bind(to: output.selectableGenderConditions)
            .disposed(by: disposeBag)
        
        let conditions = input.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { `self`, _ in self.signupUseCase.fetchAllSelectableConditions() }
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
  
            .disposed(by: disposeBag)
        
        input.didTapNextButton
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(input.didEnterTextValue)
            .withUnretained(self)
            .flatMapLatestCompletableMaterialized { `self`, nickname in
                let userInfo = UserInfoEntity(nickname: nickname, authInfo: self.authInfo)
                return self.loginUseCase.saveUserInfo(userInfo)
            }
            .filter { $0.isCompleted }
            .bind(onNext: { _ in
                coordinator.coordinate(by: .shouldFinishLoginFlow)
            })
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
        
        signupInfo
            .filter { $0.selectionType != .selectAll }
            .withLatestFrom(state.selectedConditions) { ($0, $1) }
            .flatMap { [weak self] in
                guard let self = self else { return Observable.just($1) }
                return self.signupUseCase.insertNewCondition($0, to: $1)
            }
            .bind(to: state.selectedConditions)
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
