//
//  DefaultStoolLogUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/09/14.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import Logger
import SharedDIContainer
import Utils

public final class DefaultStoolLogUseCase: StoolLogUseCase {
    
    @Inject(SharedDIContainer.shared) private var stoolLogRepository: StoolLogRepository
    // FIXME: 실제 서버와 통신하는 구현부로 변경 & 의존성 주입 방식으로 변경 예정
    private let tempUserInfoUseCase: UserInfoUseCase = TempUserInfoUseCase()
    
    public init() { }
    
    public func fetchMyLast7DaysStoolLogs() -> Observable<[StoolLogEntity]> {
        return
            .just([])
            .delay(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
        
        tempUserInfoUseCase
            .fetchUserInfo()
            .map { ($0.userId, $0.authInfo.accessToken) }
            .debug()
            .withUnretained(self)
            .flatMap { `self`, userInfo in
                let (userId, accessToken) = userInfo
                return self.stoolLogRepository
                    .fetchUserStoolLogs(accessToken: accessToken, userID: userId)
                    .map { Array($0.reversed()) }
            }
            .withUnretained(self)
            .map { `self`, stoolLogs in
                self.filterLast7DaysStoolLogs(from: stoolLogs)
            }
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func fetchAllUserStoolLogs(userID: Int) -> Observable<[StoolLogEntity]> {
        return tempUserInfoUseCase
            .fetchUserInfo()
            .map { $0.authInfo.accessToken }
            .withUnretained(self)
            .flatMap { `self`, accessToken in
                self.stoolLogRepository.fetchUserStoolLogs(
                    accessToken: accessToken,
                    userID: userID
                )
            }
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func fetchUserStoolLogs(userID: Int, date: String) -> Observable<[StoolLogEntity]> {
        return tempUserInfoUseCase
            .fetchUserInfo()
            .map { $0.authInfo.accessToken }
            .withUnretained(self)
            .flatMap { `self`, accessToken in
                self.stoolLogRepository
                    .fetchUserStoolLogs(
                        accessToken: accessToken,
                        userID: userID,
                        date: date
                    )
            }
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func postStoolLog(stoolLogEntity: StoolLogEntity) -> Observable<StoolLogEntity> {
        return tempUserInfoUseCase
            .fetchUserInfo()
            .map { $0.authInfo.accessToken }
            .withUnretained(self)
            .flatMap { `self`, accessToken in
                self.stoolLogRepository
                    .postStoolLog(
                        accessToken: accessToken,
                        stoolLogEntity: stoolLogEntity
                    )
            }
            .map { StoolLogEntity(
                postID: $0.postID,
                date: $0.date,
                stoolLogEntity: stoolLogEntity
            )}
            .logErrorIfDetected(category: .network)
            .asObservable()
    }
    
    public func convertToStoolLogItems(from stoolLogsEntities: [StoolLogEntity]) -> [StoolLogItem] {
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? calendar.timeZone
        var stoolLogItems: [StoolLogItem] = []

        for section in StoolLogListSection.allCases {
            let currentDate = getStartOfDayForSection(for: section.rawValue, relativeTo: now, using: calendar)
            let currentDayLogs = stoolLogsEntities.filter { calendar.isDate($0.date, inSameDayAs: currentDate) }

            stoolLogItems.append(contentsOf: getItemsForSection(for: currentDayLogs, in: section))
        }

        return stoolLogItems
    }
}

// MARK: - Supporting Methods

private extension DefaultStoolLogUseCase {
    func filterLast7DaysStoolLogs(from stoolLogs: [StoolLogEntity]) -> [StoolLogEntity] {
        let now = Date()
        guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now) else { return [] }
        return stoolLogs.filter { $0.date >= startDate }
    }
    
    func getStartOfDayForSection(for daysAgo: Int, relativeTo date: Date, using calendar: Calendar) -> Date {
        let dateWithDaysAgo = calendar.date(byAdding: .day, value: -daysAgo, to: date) ?? date
        return calendar.startOfDay(for: dateWithDaysAgo)
    }

    func getItemsForSection(for logs: [StoolLogEntity], in section: StoolLogListSection) -> [StoolLogItem] {
        guard !logs.isEmpty else {
            return [StoolLogItem(itemState: .empty, section: section)]
        }
        return logs.map { StoolLogItem(itemState: .stoolLog($0), section: section) }
    }
}
