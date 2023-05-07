//
//  SatisfactionSelectViewModel.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/05.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureStoolLogDIContainer
import FeatureStoolLogUseCase
import Utils

public final class SatisfactionSelectViewModel: ViewModelType {
    
    public struct Input {
        let didTapSatisfactionButton = PublishRelay<Void>()
        let didTapDisatisfactionButton = PublishRelay<Void>()
    }
    
    public struct Output {
        let isStatusSatisfied = BehaviorRelay<Bool>(value: false)
        let satisfactionButtonSelected = BehaviorRelay<Bool>(value: false)
        let disatisfactionButtonSelected = BehaviorRelay<Bool>(value: false)
    }
    
    public let input = Input()
    public let output = Output()
    
    private weak var coordinator: StoolLogCoordinator?
    private var disposeBag = DisposeBag()
    
    public init(coordinaotr: StoolLogCoordinator?) {
        self.coordinator = coordinaotr
        bindInputToOutput()
    }
    
    private func bindInputToOutput() {
        
        input.didTapSatisfactionButton
            .withLatestFrom(output.satisfactionButtonSelected)
            .map { !$0 }
            .do(onNext: { [weak self] isSatisfactionSelected in
                guard let self = self else { return }
                let isDisatisfactionSelected = self.output.disatisfactionButtonSelected.value
                
                if isSatisfactionSelected && isDisatisfactionSelected {
                    self.output.disatisfactionButtonSelected.accept(!isDisatisfactionSelected)
                }
            })
            .bind(to: output.satisfactionButtonSelected)
            .disposed(by: disposeBag)
        
        input.didTapDisatisfactionButton
            .withLatestFrom(output.disatisfactionButtonSelected)
            .map { !$0 }
            .do(onNext: { [weak self] isDisatisfactionSelected in
                guard let self = self else { return }
                let isSatisfactionSelected = self.output.satisfactionButtonSelected.value
                
                if isSatisfactionSelected && isDisatisfactionSelected {
                    self.output.satisfactionButtonSelected.accept(!isSatisfactionSelected)
                }
            })
            .bind(to: output.disatisfactionButtonSelected)
            .disposed(by: disposeBag)
    
        Observable
            .combineLatest(
                output.satisfactionButtonSelected.asObservable(),
                output.disatisfactionButtonSelected.asObservable()
            )
            .filter { isSatisfactionSelected, isDisatisfactionSelected in
                (!isSatisfactionSelected || !isDisatisfactionSelected)
                && (isSatisfactionSelected != isDisatisfactionSelected)
            }
            .withUnretained(self)
            .bind(onNext: { owner, args in
                let (isSatisfactionSelected, _) = args
                owner.coordinator?.coordinate(by: .didSelectSatisfaction(isSatisfied: isSatisfactionSelected))
            })
            .disposed(by: disposeBag)

    }
}
