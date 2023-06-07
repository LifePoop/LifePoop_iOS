//
//  FeedbackViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureSettingCoordinatorInterface
import FeatureSettingDIContainer
import FeatureSettingUseCase
import Utils

public final class FeedbackViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let suggestionButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let showSuggestionType = PublishRelay<Void>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingCoordinator?) {
        self.coordinator = coordinator
        
        input.suggestionButtonDidTap
            .bind(to: output.showSuggestionType)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("\(self) \(#function)") // TODO: Remove
    }
}
