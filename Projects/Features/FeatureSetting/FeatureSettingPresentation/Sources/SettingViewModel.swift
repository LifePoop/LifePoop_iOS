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
import Utils

public final class SettingViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let viewDidDisappear = PublishRelay<Void>()
        let profileInfoDidTap = PublishRelay<Void>()
        let useAutoLoginDidToggle = PublishRelay<Bool>()
        let termsOfserviceDidTap = PublishRelay<Void>()
        let privacyPolicyDidTap = PublishRelay<Void>()
        let feedbackDidTap = PublishRelay<Void>()
        let logoutButtonDidTap  = PublishRelay<Void>()
        let logoutCancelButtonDidTap = PublishRelay<Void>()
        let logoutConfirmButtonDidTap = PublishRelay<Void>()
        let withdrawButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let settingCellViewModels = BehaviorRelay<[any SettingCellViewModel]>(value: [])
        let footerViewModel = BehaviorRelay<SettingTableFooterViewModel?>(value: nil)
        let showLogoutAlert = PublishRelay<Void>()
        let dismissLogoutAlert = PublishRelay<Void>()
    }
    
    public struct State {
        let userLoginType = BehaviorRelay<LoginType?>(value: nil)
        let userNickname = BehaviorRelay<String>(value: "")
        let isAutoLoginOn = BehaviorRelay<Bool>(value: false)
        let version = BehaviorRelay<String>(value: "")
    }
    
    public let input = Input()
    public let output = Output()
    private let state = State()
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingCoordinator?) {
        self.coordinator = coordinator
        
        input.viewDidLoad
            .map { .kakao }
            .bind(to: state.userLoginType)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { "밀키똥" } // FIXME: Execute Nickname UseCase
            .bind(to: state.userNickname)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { true } // FIXME: Execute AutoLogin UseCase
            .bind(to: state.isAutoLoginOn)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { "1.0.1" } // FIXME: Execute Version UseCase
            .bind(to: state.version)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .map { `self`, _ in
                SettingType.allCases.map { self.generateSettingCellViewModel(by: $0) }
            }
            .bind(to: output.settingCellViewModels)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { SettingTableFooterViewModel() }
            .do { [weak self] in
                self?.bind(settingTableFooterViewModel: $0)
            }
            .bind(to: output.footerViewModel)
            .disposed(by: disposeBag)
        
        input.profileInfoDidTap
            .bind { coordinator?.coordinate(by: .profileInfoDidTap) }
            .disposed(by: disposeBag)
        
        input.useAutoLoginDidToggle
            .bind { isOn in
                // TODO: Execute AutoLogin UseCase
            }
            .disposed(by: disposeBag)
        
        input.termsOfserviceDidTap
            .map { DocumentType.termsOfService }
            .compactMap { ($0.title, Bundle.utils?.text(from: $0.textFile)) }
            .bind { coordinator?.coordinate(by: .termsOfServiceDidTap(title: $0, text: $1)) }
            .disposed(by: disposeBag)
        
        input.privacyPolicyDidTap
            .map { DocumentType.privacyPolicy }
            .compactMap { ($0.title, Bundle.utils?.text(from: $0.textFile)) }
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
            .bind {
                // TODO: Execute Logout UseCase
                coordinator?.coordinate(by: .logOutConfirmButtonDidTap)
            }
            .disposed(by: disposeBag)
        
        input.withdrawButtonDidTap
            .bind { coordinator?.coordinate(by: .withdrawButtonDidTap) }
            .disposed(by: disposeBag)
    }
    
    deinit {
        coordinator?.coordinate(by: .flowDidFinish)
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
            return SettingTextTapCellViewModel(
                model: model,
                text: state.userNickname,
                tapAction: input.profileInfoDidTap
            )
        case .autoLogin:
            return SettingSwitchCellViewModel(
                model: model,
                isSwitchOn: state.isAutoLoginOn,
                switchToggleAction: input.useAutoLoginDidToggle
            )
        case .version:
            return SettingTextCellViewModel(
                model: model,
                text: state.version
            )
        case .termsOfService:
            return SettingTapCellViewModel(
                model: model,
                tapAction: input.termsOfserviceDidTap
            )
        case .privacyPolicy:
            return SettingTapCellViewModel(
                model: model,
                tapAction: input.privacyPolicyDidTap
            )
        case .sendFeedback:
            return SettingTapCellViewModel(
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
