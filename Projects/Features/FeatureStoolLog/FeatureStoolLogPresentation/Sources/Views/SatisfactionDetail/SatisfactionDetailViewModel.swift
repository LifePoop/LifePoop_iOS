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
import FeatureStoolLogDIContainer
import FeatureStoolLogUseCase
import Logger
import Utils

public final class SatisfactionDetailViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isSatisfied = BehaviorRelay<Bool>(value: true)
        let didTapLeftBarbutton = PublishRelay<Void>()
        let didTapCompleteButton = PublishRelay<Void>()
        let didSelectColor = BehaviorRelay<StoolColor?>(value: nil)
        let didSelectShape = BehaviorRelay<StoolShape?>(value: nil)
        let didSelectSize = BehaviorRelay<StoolSize?>(value: nil)
    }
    
    public struct Output {
        let titleText = BehaviorRelay<String>(value: "")
        let sizeSelectionSegmentTitles = PublishRelay<[String]>()
        let selectableColors = Observable.of(StoolColor.allCases)
        let selectableShapes = BehaviorRelay<[ColoredStoolShape]>(value: [])
        let selectableSizes = Observable.of(StoolSize.allCases)
        let showLodingIndicator = PublishRelay<Void>()
        let hideLodingIndicator = PublishRelay<Void>()
        let enableCompleButton = BehaviorRelay<Bool>(value: false)
        let showToastMessage = PublishRelay<String>()
    }
    
    public struct State {
        let stoolLogs: BehaviorRelay<[StoolLogEntity]>
    }
    
    public let input = Input()
    public let output = Output()
    public let state: State
    
    @Inject(StoolLogDIContainer.shared) private var stoolLogUseCase: StoolLogUseCase
    
    private weak var coordinator: StoolLogCoordinator?
    private var disposeBag = DisposeBag()
    
    public init(
        coordinator: StoolLogCoordinator?,
        isSatisfied: Bool,
        stoolLogs: BehaviorRelay<[StoolLogEntity]>
    ) {
        self.coordinator = coordinator
        self.state = State(stoolLogs: stoolLogs)
        
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
            .map { $0.map { ColoredStoolShape(shape: $0, color: nil) } }
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
                input.didSelectColor.compactMap { $0 },
                input.didSelectShape.compactMap { $0 },
                input.didSelectSize.compactMap { $0 }
            )
            .map { ($0, $1, $2, $3) }
            .share()
        
        selectedStatus
            .map { _ in true }
            .bind(to: output.enableCompleButton)
            .disposed(by: disposeBag)
        
        input.didTapCompleteButton
            .bind(to: output.showLodingIndicator)
            .disposed(by: disposeBag)
        
        let newStoolLog = input.didTapCompleteButton
            .withLatestFrom(selectedStatus)
            .map { (isSatisfied, color, shape, size) -> StoolLogEntity in
                return StoolLogEntity(
                    id: 0, // FIXME: User Identifier로 변경
                    date: Date().localizedTimeString,
                    isSatisfied: isSatisfied,
                    color: color,
                    shape: shape,
                    size: size
                )
            }
            .share()
        
        let stoolLogPostResult = newStoolLog
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, newStoolLog in
                self.stoolLogUseCase.post(stoolLog: newStoolLog)
            }
            .share()
        
        stoolLogPostResult
            .filter { $0.isStopEvent }
            .map { _ in }
            .bind(to: output.hideLodingIndicator)
            .disposed(by: disposeBag)
        
        stoolLogPostResult
            .compactMap { $0.error }
            .toastMeessageMap(to: .stoolLog(.failToLog))
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        stoolLogPostResult
            .filter { $0.isCompleted }
            .withLatestFrom(newStoolLog)
            .withLatestFrom(state.stoolLogs) { ($0, $1) }
            .map { (newStoolLog, existingStoolLogs) -> [StoolLogEntity] in
                var newStoolLogs = existingStoolLogs
                newStoolLogs.append(newStoolLog)
                return newStoolLogs
            }
            .bind(to: state.stoolLogs)
            .disposed(by: disposeBag)
        
        stoolLogPostResult
            .filter { $0.isCompleted }
            .withUnretained(self)
            .bind { `self`, _ in
                self.coordinator?.coordinate(by: .dismissBottomSheet)
            }
            .disposed(by: disposeBag)
    }
}
