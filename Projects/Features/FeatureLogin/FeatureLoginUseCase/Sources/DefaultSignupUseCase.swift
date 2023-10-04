//
//  DefaultSignupUseCase.swift
//  FeatureLoginUseCase
//
//  Created by Lee, Joon Woo on 2023/06/10.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import FeatureLoginDIContainer
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultSignupUseCase: SignupUseCase {
    
    @Inject(SharedDIContainer.shared) private var userInfoUseCase: UserInfoUseCase
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    @Inject(LoginDIContainer.shared) private var signupRepository: SignupRepository
    
    public init() { }
    
    private var essentialConditions: Set<AgreementCondition> = []
    
    /** 사용자 입력 회원가입 정보로 서버에 새로운 회원정보 추가 요청 **/
    public func requestSignup(_ signupInfo: SignupInput) -> Observable<Bool> {
        
        Logger.log(
            message: """
            회원 가입 요청
            nickname: \(signupInfo.nickname)
            gender: \(signupInfo.gender.description)
            loginType: \(signupInfo.provider.description)
            """,
            category: .authentication,
            type: .debug
        )
        
        return signupRepository.requestSignup(with: signupInfo)
            .asObservable()
            .withUnretained(self)
            .flatMapLatest { `self`, authInfo in
                self.userInfoUseCase.fetchUserInfo(with: authInfo)
                    .do(onNext: {
                        Logger.log(
                            message: "회원 가입 성공 : \($0)",
                            category: .authentication,
                            type: .debug
                        )
                    })
            }
            .catchAndReturn(false)
    }
    
    // TODO: Repository로 이동
    private let conditionEntities: [AgreementCondition] = [
        .init(
            descriptionText: LocalizableString.overFourteenYearsOld,
            descriptionTextSize: .normal,
            containsDetailView: false,
            selectionType: .essential
        ),
        .init(
            descriptionText: LocalizableString.termsOfService,
            descriptionTextSize: .normal,
            containsDetailView: true,
            selectionType: .essential
        ),
        .init(
            descriptionText: LocalizableString.privacyPolicyEssential,
            descriptionTextSize: .normal,
            containsDetailView: true,
            selectionType: .essential
        ),
        .init(
            descriptionText: LocalizableString.receiveEventAndPromotionNotificationsOptional,
            descriptionTextSize: .normal,
            containsDetailView: false,
            selectionType: .optional
        )
    ]
    
    public func fetchSelectableConditions() -> Observable<[AgreementCondition]> {
        Observable.just(conditionEntities)
            .do(onNext: { [weak self] conditions in
                let essentialConditions = conditions.filter { $0.selectionType == .essential }
                self?.essentialConditions = Set(essentialConditions)
            })
    }
    
    public func isAllEsssentialConditionsSelected(
        _ selectedConditions: Set<AgreementCondition>
    ) -> Observable<Bool> {
        Observable.just(essentialConditions.isSubset(of: selectedConditions))
    }
    
    public func isNicknameInputValid(_ input: String) -> Observable<NicknameTextInput> {
        nicknameUseCase.checkNicknameValidation(for: input)
    }
    
    public func isBirthdayInputValid(_ input: String) -> Observable<BirthdayTextInput> {
        let isEmpty = input.isEmpty
        let isValid = getBirthdayInputValidation(input)
        
        if isEmpty {
            return Observable.just(.init(isValid: isValid, status: .defaultWarning))
        }
        switch isValid {
        case true:
            return Observable.just(.init(isValid: isValid, status: .possible))
        case false:
            return Observable.just(.init(isValid: isValid, status: .impossible))
        }
    }
    
    public func createFormattedDateString(with dateString: String) -> String? {
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyMMdd"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let inputDate = inputDateFormatter.date(from: dateString) else { return nil }
        return outputDateFormatter.string(from: inputDate)
    }
    
    private func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
    
    private func getBirthdayInputValidation(_ input: String) -> Bool {
        guard input.count == 6 else { return false }
        
        let numbersSet = CharacterSet.decimalDigits
        let inputCharacterSet = CharacterSet(charactersIn: input)
        guard inputCharacterSet.isSubset(of: numbersSet) else { return false }
        
        guard let year = Int(input.prefix(2)),
              let month = Int(input.dropFirst(2).prefix(2)),
              let day = Int(input.suffix(2)) else { return false }
        
        let isLeap = isLeapYear(year + 2000)
        
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return day >= 1 && day <= 31
        case 4, 6, 9, 11:
            return day >= 1 && day <= 30
        case 2:
            return day >= 1 && day <= (isLeap ? 29 : 28)
        default:
            return false
        }
    }
}
