//
//  HomeViewModel.swift
//  FeatureHomePresentation
//
//  Created by 김상혁 on 2023/05/01.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureHomeCoordinatorInterface
import FeatureHomeDIContainer
import FeatureHomeUseCase
import Logger
import Utils

public final class HomeViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let viewDidRefresh = PublishRelay<Void>()
        let settingButtonDidTap = PublishRelay<Void>()
        let reportButtonDidTap = PublishRelay<Void>()
        let stoolLogButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let shouldLoadingIndicatorAnimating = PublishRelay<Bool>()
        let shouldStartRefreshIndicatorAnimation = PublishRelay<Bool>()
        let updateStoolLogs = PublishRelay<[StoolLogItem]>()
        let bindStoolLogHeaderViewModel = PublishRelay<StoolLogHeaderViewModel>()
        let headerViewDidFinishLayoutSubviews = PublishRelay<Void>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let friends = BehaviorRelay<[FriendEntity]>(value: [])
        let stoolLogs = BehaviorRelay<[StoolLogEntity]>(value: [])
        let headerViewModel = BehaviorRelay<StoolLogHeaderViewModel?>(value: nil)
    }
    
    public let input = Input()
    public let output = Output()
    public let state = State()
    
    @Inject(HomeDIContainer.shared) private var homeUseCase: HomeUseCase
    
    private weak var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input
        
        input.viewDidLoad
            .map { _ in true }
            .bind(to: output.shouldLoadingIndicatorAnimating)
            .disposed(by: disposeBag)
        
        let viewDidLoadOrRefresh = Observable.merge(
            input.viewDidLoad.asObservable(),
            input.viewDidRefresh.asObservable()
        )
        .share()
        
        let fetchedFriends = viewDidLoadOrRefresh
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.homeUseCase.fetchFriendList()
            }
            .share()
        
        fetchedFriends
            .compactMap { $0.element }
            .bind(to: state.friends)
            .disposed(by: disposeBag)
        
        fetchedFriends
            .compactMap { $0.error }
            .map { _ in [] }
            .bind(to: state.friends)
            .disposed(by: disposeBag)
        
        fetchedFriends
            .compactMap { $0.error }
            .toastMessageMap(to: .home(.fetchFriendListFail))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let fetchedStoolLogs = viewDidLoadOrRefresh
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.homeUseCase.fetchStoolLogs()
            }
            .share()
        
        fetchedStoolLogs
            .compactMap { $0.element }
            .bind(to: state.stoolLogs)
            .disposed(by: disposeBag)
        
        fetchedStoolLogs
            .compactMap { $0.error }
            .map { _ in [] }
            .bind(to: state.stoolLogs)
            .disposed(by: disposeBag)
        
        fetchedStoolLogs
            .compactMap { $0.error }
            .toastMessageMap(to: .stoolLog(.fetchStoolLogFail))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        Observable.zip(
            fetchedFriends.filter { $0.isStopEvent }.map { _ in },
            fetchedStoolLogs.filter { $0.isStopEvent }.map { _ in }
        )
        .map { _ in false }
        .bind(to: output.shouldStartRefreshIndicatorAnimation, output.shouldLoadingIndicatorAnimating)
        .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { StoolLogHeaderViewModel(coordinator: coordinator) }
            .do { [weak self] in
                self?.bind(stoolLogHeaderViewModel: $0)
            }
            .bind(to: state.headerViewModel)
            .disposed(by: disposeBag)
        
        input.stoolLogButtonDidTap
            .withUnretained(self)
            .bind(onNext: { `self`, _ in
                `self`.coordinator?.coordinate(by: .stoolLogButtonDidTap(stoolLogsRelay: self.state.stoolLogs))
            })
            .disposed(by: disposeBag)
        
        input.settingButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                self.coordinator?.coordinate(by: .settingButtonDidTap)
            }
            .disposed(by: disposeBag)
        
        input.reportButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                self.coordinator?.coordinate(by: .reportButtonDidTap)
            }
            .disposed(by: disposeBag)
        
        state.stoolLogs
            .withUnretained(self)
            .map { `self`, stoolLogEntities in
                self.homeUseCase.convertToStoolLogItems(from: stoolLogEntities)
            }
            .bind(to: output.updateStoolLogs)
            .disposed(by: disposeBag)
        
        state.headerViewModel
            .compactMap { $0 }
            .bind(to: output.bindStoolLogHeaderViewModel)
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

private extension HomeViewModel {
    func bind(stoolLogHeaderViewModel: StoolLogHeaderViewModel) {
        input.viewDidRefresh
            .bind(to: stoolLogHeaderViewModel.input.viewDidRefresh)
            .disposed(by: disposeBag)
        
        state.friends
            .bind(to: stoolLogHeaderViewModel.state.friends)
            .disposed(by: disposeBag)
        
        stoolLogHeaderViewModel.input.viewDidFinishLayoutSubviews
            .bind(to: output.headerViewDidFinishLayoutSubviews)
            .disposed(by: disposeBag)
    }
}
