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
import SharedDIContainer
import SharedUseCase
import Utils

public final class ReportViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let periodDidSelect = PublishRelay<Int?>()
    }
    
    public struct Output {
        let updatePeriodSegmentTitles = PublishRelay<[String]>()
        let selectPeriodSegmentIndexAt = PublishRelay<Int>()
        let updatePeriodDescription = PublishRelay<String>()
        let updateStoolCountInfo = PublishRelay<(nickname: String, periodText: String, count: Int)>()
        let totalSatisfaction = PublishRelay<Int>()
        let totalDissatisfaction = PublishRelay<Int>()
        let totalStoolColor = PublishRelay<[(report: StoolColorReport, barWidthRatio: Double)]>()
        let totalStoolShape = PublishRelay<[StoolShapeReport]>()
        let totalStoolSize = PublishRelay<[StoolSizeReport]>()
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
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    
    private weak var coordinator: ReportCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: ReportCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input
        
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
                self.nicknameUseCase.nickname
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
        
        // TODO: 에러 처리 로직 구현
        fetchedUserStoolReports
            .compactMap { $0.error }
        
        // TODO: 서버 응답시간 고려하여 Indicator 등 구현
        fetchedUserStoolReports
            .filter { $0.isStopEvent }
        
        input.periodDidSelect
            .compactMap { $0 }
            .compactMap { ReportPeriod(rawValue: $0) }
            .bind(to: state.selectedPeriod)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State
        
        let userStoolReport = Observable.combineLatest(
            state.selectedPeriod.compactMap { $0 },
            state.userStoolReportMap
        )
        .compactMap { selectedPeriod, userStoolReportMap in
            userStoolReportMap[selectedPeriod]
        }
        .share()
        
        let userNickname = fetchedUserNickname
            .compactMap { $0.element }
            .compactMap { $0 }
            .share()
        
        let stoolCountInfo = userStoolReport
            .map { ($0.period.description, $0.totalStoolCount) }
            .share()
        
        Observable.combineLatest(userNickname, stoolCountInfo)
            .map { nickname, info in
                let (periodText, count) = info
                return (nickname: nickname, periodText: periodText, count: count)
            }
            .bind(to: output.updateStoolCountInfo)
            .disposed(by: disposeBag)
        
        userStoolReport
            .map { $0.totalSatisfaction }
            .bind(to: output.totalSatisfaction)
            .disposed(by: disposeBag)
        
        userStoolReport
            .map { $0.totalDissatisfaction }
            .bind(to: output.totalDissatisfaction)
            .disposed(by: disposeBag)
        
        userStoolReport
            .map { $0.totalStoolColor.filter { $0.count > 0 } }
            .withUnretained(self)
            .map { `self`, reports in
                self.sortMaxCount(for: reports)
            }
            .withUnretained(self)
            .map { `self`, reports in
                self.calculateRatioFromMaxCount(reports: reports)
            }
            .bind(to: output.totalStoolColor)
            .disposed(by: disposeBag)
        
        userStoolReport
            .map { $0.totalStoolShape }
            .bind(to: output.totalStoolShape)
            .disposed(by: disposeBag)
        
        userStoolReport
            .map { $0.totalStoolSize }
            .bind(to: output.totalStoolSize)
            .disposed(by: disposeBag)
        
        state.selectedPeriod
            .compactMap { $0?.description }
            .map { "최근 \($0) 내 배변일지" }
            .bind(to: output.updatePeriodDescription)
            .disposed(by: disposeBag)
    }
    
    deinit {
        Logger.logDeallocation(object: self)
    }
}

// FIXME: Calculating Methods - 해당 연산 작업은 서버에서 수행하므로 삭제 예정

private extension ReportViewModel {
    func calculateRatioFromMaxCount(reports: [StoolColorReport]) -> [(StoolColorReport, Double)] {
        guard let maxCount = reports.max(by: { $0.count < $1.count })?.count else { return [] }
        return reports.map { ($0, Double($0.count) / Double(maxCount)) }
    }
    
    func sortMaxCount(for reports: [StoolColorReport]) -> [StoolColorReport] {
        return reports.sorted { $0.count > $1.count }
    }
}
