//
//  SettingViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/10.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureSettingCoordinatorInterface
import FeatureSettingDIContainer
import FeatureSettingUseCase
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class SettingViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let profileInfoDidTap = PublishRelay<Void>()
        let feedVisibilityDidTap = PublishRelay<Void>()
        let useAutoLoginDidToggle = PublishRelay<Bool>()
        let termsOfserviceDidTap = PublishRelay<Void>()
        let privacyPolicyDidTap = PublishRelay<Void>()
        let feedbackDidTap = PublishRelay<Void>()
        let logoutButtonDidTap  = PublishRelay<Void>()
        let logoutCancelButtonDidTap = PublishRelay<Void>()
        let logoutConfirmButtonDidTap = PublishRelay<Void>()
        let withdrawButtonDidTap = PublishRelay<Void>()
        let withdrawCancelButtonDidTap = PublishRelay<Void>()
        let withdrawConfirmButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let updateSettingCellViewModels = PublishRelay<[any SettingCellViewModel]>()
        let updateFooterViewModel = PublishRelay<SettingTableFooterViewModel>()
        let showLogoutAlert = PublishRelay<Void>()
        let showWithdrawAlert = PublishRelay<Void>()
        let dismissLogoutAlert = PublishRelay<Void>()
        let dismissWithdrawAlert = PublishRelay<Void>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let settingCellViewModels = BehaviorRelay<[any SettingCellViewModel]>(value: [])
        let footerViewModel = BehaviorRelay<SettingTableFooterViewModel?>(value: nil)
        let userLoginType = BehaviorRelay<LoginType?>(value: nil)
        let userNickname = BehaviorRelay<String?>(value: nil)
        let feedVisibility = BehaviorRelay<FeedVisibility?>(value: nil)
        let isAutoLoginOn = BehaviorRelay<Bool?>(value: nil)
        let version = BehaviorRelay<String?>(value: nil)
    }
    
    public let input = Input()
    public let output = Output()
    private let state = State()
    
    @Inject(SettingDIContainer.shared) private var userSettingUseCase: UserSettingUseCase
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase

    @Inject(SharedDIContainer.shared) private var bundleResourceUseCase: BundleResourceUseCase
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.userSettingUseCase.loginType
            }
            .compactMap { $0.element }
            .bind(to: state.userLoginType)
            .disposed(by: disposeBag)

        input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.userSettingUseCase.nickname
            }
            .compactMap { $0.element }
            .bind(to: state.userNickname)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.userSettingUseCase.feedVisibility
            }
            .compactMap { $0.element }
            .bind(to: state.feedVisibility)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.userSettingUseCase.isAutoLoginActivated
            }
            .compactMap { $0.element }
            .bind(to: state.isAutoLoginOn)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.bundleResourceUseCase.determineAppVersion()
            }
            .compactMap { $0.element }
            .bind(to: state.version)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .map { `self`, _ in
                SettingType.allCases.map { self.generateSettingCellViewModel(by: $0) }
            }
            .bind(to: state.settingCellViewModels)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { SettingTableFooterViewModel() }
            .do { [weak self] in
                self?.bind(settingTableFooterViewModel: $0)
            }
            .bind(to: state.footerViewModel)
            .disposed(by: disposeBag)
        
        input.profileInfoDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(by: .profileInfoDidTap(userNickname: self.state.userNickname))
            }
            .disposed(by: disposeBag)
        
        input.feedVisibilityDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(by: .feedVisibilityDidTap(feedVisibility: self.state.feedVisibility))
            }
            .disposed(by: disposeBag)
        
        input.useAutoLoginDidToggle
            .bind(to: state.isAutoLoginOn)
            .disposed(by: disposeBag)
        
        input.termsOfserviceDidTap
            .map { DocumentType.termsOfService }
            .withUnretained(self)
            .flatMapMaterialized { `self`, documentType -> Observable<(String, String)> in
                let title = Observable.just(documentType.title)
                let text = self.bundleResourceUseCase.readText(from: documentType.textFile)
                return Observable.zip(title, text)
            }
            .compactMap { $0.element }
            .bind { coordinator?.coordinate(by: .termsOfServiceDidTap(title: $0, text: $1)) }
            .disposed(by: disposeBag)
        
        input.privacyPolicyDidTap
            .map { DocumentType.privacyPolicy }
            .withUnretained(self)
            .flatMapMaterialized { `self`, documentType -> Observable<(String, String)> in
                let title = Observable.just(documentType.title)
                let text = self.bundleResourceUseCase.readText(from: documentType.textFile)
                return Observable.zip(title, text)
            }
            .compactMap { $0.element }
            .bind { coordinator?.coordinate(by: .termsOfServiceDidTap(title: $0, text: $1)) }
            .disposed(by: disposeBag)
        
        input.feedbackDidTap
            .bind { coordinator?.coordinate(by: .sendFeedbackDidTap) }
            .disposed(by: disposeBag)
        
        input.logoutButtonDidTap
            .bind(to: output.showLogoutAlert)
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.logoutCancelButtonDidTap.asObservable(),
            input.logoutConfirmButtonDidTap.asObservable()
        )
        .bind(to: output.dismissLogoutAlert)
        .disposed(by: disposeBag)
        
        input.logoutConfirmButtonDidTap
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.userInfoUseCase.requestLogout()
            }
            .bind(onNext: { isSuccess in
                if isSuccess {
                    coordinator?.coordinate(by: .logOutConfirmButtonDidTap)
                } else {
                    print("로그아웃 실패 모달 띄우기")
                }
            })
            .disposed(by: disposeBag)

        input.withdrawButtonDidTap
            .bind(to: output.showWithdrawAlert)
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.withdrawCancelButtonDidTap.asObservable(),
            input.withdrawConfirmButtonDidTap.asObservable()
        )
        .bind(to: output.dismissWithdrawAlert)
        .disposed(by: disposeBag)
        
        input.withdrawConfirmButtonDidTap
            .withLatestFrom(state.userLoginType)
            .compactMap { $0 }
            .withUnretained(self)
            .flatMap { `self`, loginType in
                self.userInfoUseCase.requestAccountWithdrawl(for: loginType)
            }
            .withUnretained(self)
            .bind { `self`, isSuccess in
                if isSuccess {
                    self.coordinator?.coordinate(by: .withdrawConfirmButtonDidTap)
                } else {
                    print("탈퇴 실패 모달 띄우기")
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - Bind State
        
        state.settingCellViewModels
            .bind(to: output.updateSettingCellViewModels)
            .disposed(by: disposeBag)
        
        state.footerViewModel
            .compactMap { $0 }
            .bind(to: output.updateFooterViewModel)
            .disposed(by: disposeBag)
        
        state.feedVisibility
            .distinctUntilChanged()
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, isActivated in
                self.userSettingUseCase.updateFeedVisibility(to: isActivated)
            }
            .compactMap { $0.error }
            .toastMessageMap(to: .setting(.changeFeedVisibilityFail))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        state.isAutoLoginOn
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, isActivated in
                self.userSettingUseCase.updateIsAutoLoginActivated(to: isActivated)
            }
            .compactMap { $0.error }
            .toastMessageMap(to: .setting(.changeIsAutoLoginFail))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
    }
    
    deinit {
        coordinator?.coordinate(by: .flowDidFinish)
        Logger.logDeallocation(object: self)
    }
}

// MARK: - Supporting Methods

private extension SettingViewModel {
    func generateSettingCellViewModel(by settingType: SettingType) -> any SettingCellViewModel {
        let model = SettingModelFactory.createModel(for: settingType)
        switch settingType {
        case .loginType:
            return SettingLoginTypeCellViewModel(
                model: model,
                loginType: state.userLoginType
            )
        case .profile:
            let cellViewModel = SettingTapActionCellViewModel(
                model: model,
                tapAction: input.profileInfoDidTap
            )
            cellViewModel.bindCellText(with: state.userNickname)
            return cellViewModel
        case .version:
            return SettingTextCellViewModel(
                model: model,
                text: state.version
            )
        case .termsOfService:
            return SettingTapActionCellViewModel(
                model: model,
                tapAction: input.termsOfserviceDidTap
            )
        case .privacyPolicy:
            return SettingTapActionCellViewModel(
                model: model,
                tapAction: input.privacyPolicyDidTap
            )
        case .sendFeedback:
            return SettingTapActionCellViewModel(
                model: model,
                tapAction: input.feedbackDidTap
            )
        }
    }
    
    func bind(settingTableFooterViewModel: SettingTableFooterViewModel) {
        settingTableFooterViewModel.input.logOutButtonDidTap
            .bind(to: input.logoutButtonDidTap)
            .disposed(by: disposeBag)
        
        settingTableFooterViewModel.input.withdrawalButtonDidTap
            .bind(to: input.withdrawButtonDidTap)
            .disposed(by: disposeBag)
    }
}
