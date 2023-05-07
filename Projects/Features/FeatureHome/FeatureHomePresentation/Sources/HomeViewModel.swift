//
//  HomeViewModel.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureHomeDIContainer
import FeatureHomeUseCase
import Utils

public final class HomeViewModel: ViewModelType {
    
    public struct Input {
        let stoolLogButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        
    }
    
    public let input = Input()
    public let output = Output()
    
    @Inject(HomeDIContainer.shared) private var homeUseCase: HomeUseCase
    
    private weak var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - stoolLogButtonDidTap
        input.stoolLogButtonDidTap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.coordinate(by: .stoolLogButtonDidTap)
            })
            .disposed(by: disposeBag)
        
    }
}
