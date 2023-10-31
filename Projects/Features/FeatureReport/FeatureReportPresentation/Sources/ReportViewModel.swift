//
//  ReportViewModel.swift
//  FeatureReportPresentation
//
//  Created by 김상혁 on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureReportCoordinatorInterface
import FeatureReportDIContainer
import FeatureReportUseCase
import Logger
import Utils

public final class ReportViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let periodDidSelect = PublishRelay<Int?>()
    }
    
    public struct Output {
        let shouldLoadingIndicatorAnimating = PublishRelay<Bool>()
        let updatePeriodSegmentTitles = PublishRelay<[String]>()
        let selectPeriodSegmentIndexAt = PublishRelay<Int>()
        let updateStoolCountInfo = PublishRelay<(nickname: String, periodText: String, count: Int)>()
        let totalSatisfaction = PublishRelay<Int>()
        let totalDissatisfaction = PublishRelay<Int>()
        let totalStoolColorReport = PublishRelay<[StoolColorReport]>()
        let totalStoolShapeCountMap = PublishRelay<[StoolShape: Int]>()
        let totalStoolSizeCountMap = PublishRelay<[StoolShapeSize: Int]>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let selectedPeriod = BehaviorRelay<ReportPeriod?>(value: nil)
        let userStoolReportMap = BehaviorRelay<[ReportPeriod: StoolReport]>(value: [:])
    }
    
    public let input = Input()
    public let output = Output()
    public let state = State()
    
    @Inject(ReportDIContainer.shared) private var reportUseCase: ReportUseCase
    
    private weak var coordinator: ReportCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: ReportCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input
        
        input.viewDidLoad
            .map { _ in true }
            .bind(to: output.shouldLoadingIndicatorAnimating)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { ReportPeriod.titles }
            .bind(to: output.updatePeriodSegmentTitles)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { .zero }
            .bind(to: output.selectPeriodSegmentIndexAt)
            .disposed(by: disposeBag)
        
        let fetchedUserNickname = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.reportUseCase.fetchUserNickname()
            }
            .share()
        
        let fetchedUserStoolReports = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.reportUseCase.fetchAllUserStoolReports()
            }
            .share()
        
        fetchedUserStoolReports
            .compactMap { $0.element }
            .map { reports in
                reports.reduce(into: [ReportPeriod: StoolReport]()) { (result, report) in
                    result[report.period] = report
                }
            }
            .bind(to: state.userStoolReportMap)
            .disposed(by: disposeBag)
        
        fetchedUserStoolReports
            .compactMap { $0.error }
            .toastMessageMap(to: .stoolLog(.fetchStoolLogFail))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        fetchedUserStoolReports
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.shouldLoadingIndicatorAnimating)
            .disposed(by: disposeBag)
        
        input.periodDidSelect
            .compactMap { $0 }
            .compactMap { ReportPeriod(rawValue: $0) }
            .bind(to: state.selectedPeriod)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State
        
        let userStoolReportForSelectedPeriod = Observable.combineLatest(
            state.selectedPeriod.compactMap { $0 },
            state.userStoolReportMap
        )
            .compactMap { selectedPeriod, userStoolReportMap in
                userStoolReportMap[selectedPeriod]
            }
            .share()
        
        let userNickname = fetchedUserNickname
            .compactMap { $0.element }
            .map { $0 }
            .share()
        
        let stoolCountInfo = userStoolReportForSelectedPeriod
            .map { ($0.period.description, $0.totalStoolCount) }
            .share()
        
        Observable.combineLatest(userNickname, stoolCountInfo)
            .map { nickname, info in
                let (periodText, count) = info
                return (nickname: nickname, periodText: periodText, count: count)
            }
            .bind(to: output.updateStoolCountInfo)
            .disposed(by: disposeBag)
        
        userStoolReportForSelectedPeriod
            .map { $0.totalSatisfaction }
            .bind(to: output.totalSatisfaction)
            .disposed(by: disposeBag)
        
        userStoolReportForSelectedPeriod
            .map { $0.totalDissatisfaction }
            .bind(to: output.totalDissatisfaction)
            .disposed(by: disposeBag)
        
        userStoolReportForSelectedPeriod
            .withUnretained(self)
            .map { `self`, report in
                let (stoolColorCountMap, count) = (report.totalStoolColorCountMap, report.totalStoolCount)
                return self.sortedColorCountsAndRatios(from: stoolColorCountMap, totalCount: count)
            }
            .bind(to: output.totalStoolColorReport)
            .disposed(by: disposeBag)
        
        userStoolReportForSelectedPeriod
            .map { $0.totalStoolShapeCountMap }
            .bind(to: output.totalStoolShapeCountMap)
            .disposed(by: disposeBag)
        
        userStoolReportForSelectedPeriod
            .map { $0.totalStoolShapeSizeCountMap }
            .bind(to: output.totalStoolSizeCountMap)
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

private extension ReportViewModel {
    func sortedColorCountsAndRatios(from colorCounts: [StoolColor: Int], totalCount: Int) -> [StoolColorReport] {
        let sortedCounts = colorCounts
            .filter { $0.value > .zero }
            .sorted { $0.value > $1.value }
        
        let maxCount = sortedCounts.first?.value ?? 1
        
        return sortedCounts.map {
            StoolColorReport(color: $0.key, count: $0.value, barWidthRatio: Double($0.value) / Double(maxCount))
        }
    }
}
