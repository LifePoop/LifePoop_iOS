//
//  FeedVisibilityViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/28.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureSettingCoordinatorInterface
import FeatureSettingDIContainer
import FeatureSettingUseCase
import SharedDIContainer
import SharedUseCase
import Utils

public final class FeedVisibilityViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let feedVisibilityDidSelectAt = PublishRelay<Int>()
    }
    
    public struct Output {
        let selectFeedVisibilityAt = PublishRelay<Int>()
    }
    
    public struct State {
        let feedVisibility: BehaviorRelay<FeedVisibility?>
    }
    
    public let input = Input()
    public let output = Output()
    public let state: State
    
    @Inject(SharedDIContainer.shared) private var feedVisibilityUseCase: FeedVisibilityUseCase
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingCoordinator?, feedVisibility: BehaviorRelay<FeedVisibility?>) {
        self.coordinator = coordinator
        self.state = State(feedVisibility: feedVisibility)
        
        input.viewDidLoad
            .withLatestFrom(state.feedVisibility)
            .compactMap { $0?.index }
            .bind(to: output.selectFeedVisibilityAt)
            .disposed(by: disposeBag)
        
        input.feedVisibilityDidSelectAt
            .compactMap { FeedVisibility[$0] }
            .bind(to: state.feedVisibility)
            .disposed(by: disposeBag)
        
        state.feedVisibility
            .compactMap { $0?.index }
            .bind(to: output.selectFeedVisibilityAt)
            .disposed(by: disposeBag)
    }
}
