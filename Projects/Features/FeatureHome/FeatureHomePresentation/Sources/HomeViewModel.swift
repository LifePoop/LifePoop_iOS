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
        let viewDidLoad = PublishRelay<Void>()
        let settingButtonDidTap = PublishRelay<Void>()
        let reportButtonDidTap = PublishRelay<Void>()
        let stoolLogButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let friends = BehaviorRelay<[FriendEntity]>(value: [])
        let stoolLogs = BehaviorRelay<[StoolLogEntity]>(value: [])
        let showErrorMessage = PublishRelay<String>()
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
        
        let fetchedFriends = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.homeUseCase.fetchFriendList()
            }
            .share()
        
        fetchedFriends
            .compactMap { $0.element }
            .bind(to: output.friends)
            .disposed(by: disposeBag)
        
        fetchedFriends
            .compactMap { $0.error }
            .toastMeessageMap(to: .failToFetchFriendList)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let stoolLogs = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.homeUseCase.fetchStoolLogs()
            }
            .share()
        
        stoolLogs
            .compactMap { $0.element }
            .bind(to: output.stoolLogs)
            .disposed(by: disposeBag)
        
        stoolLogs
            .compactMap { $0.error }
            .toastMeessageMap(to: .failToFetchStoolLog)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
    }
}
