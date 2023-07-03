//
//  WithdrawalViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureSettingCoordinatorInterface
import FeatureSettingDIContainer
import FeatureSettingUseCase
import Utils

@available(*, deprecated, message: "탈퇴 사유 선택하지 않는 것으로 변경됨")
public final class WithdrawalViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let reasonDidSelectAt = PublishRelay<Int>()
        let withdrawButtonDidTap = PublishRelay<Void>()
        let withdrawCancelButtonDidTap = PublishRelay<Void>()
        let withdrawConfirmButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let enableWithdrawButton = PublishRelay<Bool>()
        let placeholder = BehaviorRelay<String>(value: "")
        let selectReasonAt = PublishRelay<Int>()
        let showWithdrawAlert = PublishRelay<Void>()
        let dismissWithdrawAlert = PublishRelay<Void>()
    }
    
    private struct State {
        let selectedReason = BehaviorRelay<WithdrawReason?>(value: nil)
    }
    
    public let input = Input()
    public let output = Output()
    private let state = State()
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingCoordinator?) {
        self.coordinator = coordinator
        
        // TODO: Execute Withdraw UseCase
        
        input.reasonDidSelectAt
            .map { WithdrawReason(rawValue: $0) }
            .bind(to: state.selectedReason)
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
            .withLatestFrom(state.selectedReason)
            .withUnretained(self)
            .bind { `self`, selectedReason in
                // TODO: Execute Withdraw UseCase
                self.coordinator?.coordinate(by: .withdrawConfirmButtonDidTap)
            }
            .disposed(by: disposeBag)
        
        state.selectedReason
            .map { $0 != nil }
            .bind(to: output.enableWithdrawButton)
            .disposed(by: disposeBag)
        
        state.selectedReason
            .compactMap { $0?.index }
            .bind(to: output.selectReasonAt)
            .disposed(by: disposeBag)
    }
}
