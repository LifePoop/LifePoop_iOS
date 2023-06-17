//
//  SatisfactionDetailViewModel.swift
//  FeatureStoolLogPresentation
//
//  Created by 이준우 on 2023/05/06.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureStoolLogCoordinatorInterface
import Logger
import Utils

public final class SatisfactionDetailViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isSatisfied = BehaviorRelay<Bool>(value: true)
        let didTapLeftBarbutton = PublishRelay<Void>()
        let didTapCompleteButton = PublishRelay<Void>()
        let didSelectColor = PublishRelay<StoolColor>()
        let didSelectShape = PublishRelay<StoolShape>()
        let didSelectSize = PublishRelay<StoolSize>()
    }
    
    public struct Output {
        let titleText = BehaviorRelay<String>(value: "")
        let sizeSelectionSegmentTitles = PublishRelay<[String]>()
        let selectableColors = Observable.of(StoolColor.allCases)
        let selectableShapes = BehaviorRelay<[ColoredStoolShape]>(value: [])
        let selectableSizes = Observable.of(StoolSize.allCases)
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
        
        input.viewDidLoad
            .map { StoolSize.allCases.map { $0.description } }
            .bind(to: output.sizeSelectionSegmentTitles)
            .disposed(by: disposeBag)
        
        input.isSatisfied
            .map { $0 ? "만족한 이유를 알려주세요!" : "불만족한 이유를 알려주세요!" }
            .bind(to: output.titleText)
            .disposed(by: disposeBag)
        
        Observable.of(StoolShape.allCases)
            .map { $0.map { ColoredStoolShape(shape: $0, color: .brown) } }
            .bind(to: output.selectableShapes)
            .disposed(by: disposeBag)
        
        input.didTapLeftBarbutton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.coordinate(by: .goBack)
            })
            .disposed(by: disposeBag)
        
        input.didSelectColor
            .withLatestFrom(input.didSelectShape) {
                (selectedColor: $0, selectedShape: $1)
            }
            .map { selectedColor, selectedShape in
                StoolShape.allCases.map {
                    let isSelected = selectedShape == $0
                    return ColoredStoolShape(shape: $0, color: selectedColor, isSelected: isSelected)
                }
            }
            .bind(to: output.selectableShapes)
            .disposed(by: disposeBag)
        
        let selectedStatus = Observable
            .combineLatest(
                input.isSatisfied,
                input.didSelectColor,
                input.didSelectShape,
                input.didSelectSize
            )
            .map { ($0, $1, $2, $3) }
            .share()
        
        input.didTapCompleteButton
            .withLatestFrom(selectedStatus)
            .withUnretained(self)
            .bind(onNext: { owner, selectedStatus in
                Logger.log(message: "선택된 값 확인 : \(selectedStatus)", category: .default, type: .debug)
                owner.coordinator?.coordinate(by: .dismissBottomSheet)
            })
            .disposed(by: disposeBag)
    }
}
