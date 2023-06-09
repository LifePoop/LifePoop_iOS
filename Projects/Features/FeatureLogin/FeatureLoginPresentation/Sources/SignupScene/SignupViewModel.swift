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
<<<<<<< HEAD:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/SignupScene/SignupViewModel.swift
import Utils

public final class SignupViewModel: ViewModelType {
=======

import Utils

public final class NicknameViewModel: ViewModelType {

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
        let didSelectConfirmCondition = PublishRelay<SelectableConfirmationCondition>()
        let didDeselectConfirmCondition = PublishRelay<SelectableConfirmationCondition>()
        let didTapLeftBarbutton = PublishRelay<Void>()
        let didTapDetailViewButton = PublishRelay<DetailViewType>()
        let viewDidLoad = PublishRelay<Void>()
    }
    
    public struct Output {
        let textFieldStatus = BehaviorRelay<NicknameInputStatus.Status>(value:
                .none(description: "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다.")
        )
<<<<<<< HEAD:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/SignupScene/SignupViewModel.swift
        let shouldCheckCondition = PublishRelay<Int>()
        let selectAllCondition = Observable.just(SelectableConfirmationCondition(
            descriptionText: "전체동의",
            descriptionTextSize: .large,
            detailTerms: nil,
            selectionType: .selectAll
        ))
        let selectableGenderConditions = BehaviorRelay<[String]>(value: [])
=======
>>>>>>> develop:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/NicknameScene/NicknameViewModel.swift
        let selectableConditions = BehaviorRelay<[SelectableConfirmationCondition]>(value: [])
        let activateNextButton = BehaviorRelay<Bool>(value: false)
        let selectAllConditions = PublishRelay<Bool>()
    }
    
    public struct State {
        let selectedConditions = BehaviorRelay<Set<SelectableConfirmationCondition>>(value: [])
        let essentialConditions = BehaviorRelay<Set<SelectableConfirmationCondition>>(value: [])
        let didSelectAllEssentialConditions = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
    private let state = State()
    
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
<<<<<<< HEAD:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/SignupScene/SignupViewModel.swift
    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase
    @Inject(LoginDIContainer.shared) private var signupUseCase: SignupUseCase
=======

    @Inject(SharedDIContainer.shared) private var bundleResourceUseCase: BundleResourceUseCase
    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase

    private var selectedConditions: Set<SelectableConfirmationCondition> = [] {
        didSet {
            input.didSelectAllEssentialConditions.accept(
                essentialConditions.isSubset(of: selectedConditions)
            )
        }
    }
    private var essentialConditions: Set<SelectableConfirmationCondition> = []
    
    private let conditionEntities: [SelectableConfirmationCondition] = [
        .init(
            descriptionText: "전체동의",
            descriptionTextSize: .large,
            containsDetailView: false,
            selectionType: .selectAll
        ),
        .init(
            descriptionText: "만 14세 이상입니다.(필수)",
            descriptionTextSize: .normal,
            containsDetailView: false,
            selectionType: .essential
        ),
        .init(
            descriptionText: "서비스 이용 약관 (필수)",
            descriptionTextSize: .normal,
            containsDetailView: true,
            selectionType: .essential
        ),
        .init(
            descriptionText: "개인정보 수집 및 이용 (필수)",
            descriptionTextSize: .normal,
            containsDetailView: true,
            selectionType: .essential
        ),
        .init(
            descriptionText: "이벤트, 프로모션 알림 메일 수신 (선택)",
            descriptionTextSize: .normal,
            containsDetailView: false,
            selectionType: .optional
        )
    ]
>>>>>>> develop:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/NicknameScene/NicknameViewModel.swift

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
        
        conditions
            .map { Set($0.filter { $0.selectionType == .essential }) }
            .bind(to: state.essentialConditions)
            .disposed(by: disposeBag)
        
        conditions
            .bind(to: output.selectableConditions)
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
        
        let didSelectCondition = input.didSelectConfirmCondition.share()
        
        didSelectCondition
            .filter { $0.selectionType == .selectAll }
            .map { _ in true }
            .bind(to: output.selectAllConditions)
            .disposed(by: disposeBag)
        
        didSelectCondition
            .filter { $0.selectionType != .selectAll }
            .withLatestFrom(state.selectedConditions) { ($0, $1) }
            .flatMap { [weak self] in
                guard let self = self else { return Observable.just($1) }
                return self.signupUseCase.insertNewCondition($0, to: $1)
            }
            .bind(to: state.selectedConditions)
            .disposed(by: disposeBag)

        let didDeselectCondition = input.didDeselectConfirmCondition.share()
        
        didDeselectCondition
            .filter { $0.selectionType == .selectAll }
            .map { _ in false }
            .bind(to: output.selectAllConditions)
            .disposed(by: disposeBag)

        didDeselectCondition
            .filter { $0.selectionType != .selectAll }
            .withLatestFrom(state.selectedConditions) { ($0, $1) }
            .flatMap { [weak self] in
                guard let self = self else { return Observable.just($1) }
                return self.signupUseCase.removeExistingCondition($0, from: $1)
            }
            .bind(to: state.selectedConditions)
            .disposed(by: disposeBag)
        
        Observable
            .merge(didSelectCondition, didDeselectCondition)
            .filter { $0.selectionType != .selectAll }
            .withLatestFrom(state.selectedConditions) { ($0, $1) }
            .flatMap { [weak self] in
                guard let self = self else { return Observable.just($1) }
                return self.signupUseCase.insertNewCondition($0, to: $1)
            }
            .bind(to: state.selectedConditions)
            .disposed(by: disposeBag)

        
        let fetchDetailFormFile = input.didTapDetailViewButton
            .map { detailType in
                switch detailType {
                case .privacyPolicy:
                    return DocumentType.privacyPolicy
                case .termsOfService:
                    return DocumentType.termsOfService
                }
            }
            .withUnretained(self)
            .flatMapLatest { `self`, documentType in
                Observable.zip(
                    Observable.just(documentType.title),
                    self.bundleResourceUseCase.readText(from: documentType.textFile)
                )
            }
            .share()
        
        fetchDetailFormFile
            .bind(onNext: { title, detailText in
                coordinator.coordinate(by: .shouldShowDetailForm(title: title, detailText: detailText))
            })
            .disposed(by: disposeBag)
        
        output.selectAllConditions
            .withLatestFrom(output.selectableConditions) {
                ($0, Set($1.filter { $0.selectionType != .selectAll }))
            }
            .map { $0 ? $1 : [] }
            .bind(to: state.selectedConditions)
            .disposed(by: disposeBag)
        
        state.selectedConditions
            .withLatestFrom(state.essentialConditions) { ($0, $1) }
            .flatMap { [weak self] in
                guard let self = self else { return Observable.just(false) }
                return self.signupUseCase.isAllConditionSatisfied(
                    selectedConditions: $0,
                    essentialConditions: $1
                )
            }
            .bind(to: state.didSelectAllEssentialConditions)
            .disposed(by: disposeBag)

        let nicknameInputStatus = input.didEnterTextValue
            .withUnretained(self)
            .flatMap { `self`, input in
                self.nicknameUseCase.checkNicknameValidation(for: input)
            }
            .share()
        
        nicknameInputStatus
            .map { $0.status }
            .bind(to: output.textFieldStatus)
            .disposed(by: disposeBag)
        
        Observable
<<<<<<< HEAD:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/SignupScene/SignupViewModel.swift
            .combineLatest(state.didSelectAllEssentialConditions, nicknameInputStatus)
=======
            .combineLatest(input.didSelectAllEssentialConditions, nicknameInputStatus)
>>>>>>> develop:Projects/Features/FeatureLogin/FeatureLoginPresentation/Sources/NicknameScene/NicknameViewModel.swift
            .map { $0 && $1.isValid }
            .bind(to: output.activateNextButton)
            .disposed(by: disposeBag)
    }
}
