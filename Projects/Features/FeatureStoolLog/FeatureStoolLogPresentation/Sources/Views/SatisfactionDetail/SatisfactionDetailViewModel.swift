//
//  SatisfactionDetailViewModel.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureStoolLogCoordinatorInterface
import Utils

public final class SatisfactionDetailViewModel: ViewModelType {
    
    public struct Input {
        let isSatisfied = BehaviorRelay<Bool>(value: true)
        let didTapLeftBarbutton = PublishRelay<Void>()
        let didTapCompleteButton = PublishRelay<Void>()
        let didSelectColor = PublishRelay<SelectableColor>()
        let didSelectStiffness = PublishRelay<SelectableStiffness>()
        let didSelectSize = PublishRelay<SelectableSize>()
    }
    
    public struct Output {
        let titleText = BehaviorRelay<String>(value: "왜 만족했나요?")
        let selectableColors = Observable.of(SelectableColor.allCases)
        let selectableStiffnessList = Observable.of(SelectableStiffness.allCases)
        let selectableSizes = Observable.of(SelectableSize.allCases)
    }
    
    public let input = Input()
    public let output = Output()
    
    private weak var coordinator: StoolLogCoordinator?
    private var disposeBag = DisposeBag()
        
    public init(coordinator: StoolLogCoordinator?, isSatisfied: Bool) {
        self.coordinator = coordinator
        bindInputToOutput()

        input.isSatisfied.accept(isSatisfied)
    }
    
    private func bindInputToOutput() {
        
        input.isSatisfied
            .map { $0 ? "왜 만족했나요?" : "왜 불만족했나요?" }
            .bind(to: output.titleText)
            .disposed(by: disposeBag)
        
        input.didTapLeftBarbutton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.coordinate(by: .goBack)
            })
            .disposed(by: disposeBag)
                
        let selectedStatus = Observable
            .combineLatest(
                input.isSatisfied,
                input.didSelectColor,
                input.didSelectStiffness,
                input.didSelectSize
            )
            .map { ($0, $1, $2, $3) }
            .share()
        
        input.didTapCompleteButton
            .withLatestFrom(selectedStatus)
            .withUnretained(self)
            .bind(onNext: { owner, selectedStatus in
                print("선택된 값 확인 : \(selectedStatus)")
                owner.coordinator?.coordinate(by: .dismissBottomSheet)
            })
            .disposed(by: disposeBag)

    }

}
