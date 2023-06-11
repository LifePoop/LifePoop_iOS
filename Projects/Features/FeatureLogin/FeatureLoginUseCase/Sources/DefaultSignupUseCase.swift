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

    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase

    public init() { }
    
    private var essentialConditions: Set<SelectableConfirmationCondition> = []
    
    // TODO: Repository로 이동
    private let conditionEntities: [SelectableConfirmationCondition] = [
        .init(
            descriptionText: "만 14세 이상입니다.(필수)",
            descriptionTextSize: .normal,
            containsDetailView: false,
            selectionType: .essential
        ),
        .init(
            descriptionText: "서비스 이용 약관 (필수)",
            descriptionTextSize: .normal,
            containsDetailView: true,
            selectionType: .essential
        ),
        .init(
            descriptionText: "개인정보 수집 및 이용 (필수)",
            descriptionTextSize: .normal,
            containsDetailView: true,
            selectionType: .essential
        ),
        .init(
            descriptionText: "이벤트, 프로모션 알림 메일 수신 (선택)",
            descriptionTextSize: .normal,
            containsDetailView: false,
            selectionType: .optional
        )
    ]
    
    public func fetchSelectableConditions() -> Observable<[SelectableConfirmationCondition]> {
        Observable.just(conditionEntities)
            .do(onNext: { [weak self] conditions in
                let essentialConditions = conditions.filter { $0.selectionType == .essential }
                self?.essentialConditions = Set(essentialConditions)
            })
    }
    
    public func isAllEsssentialConditionsSelected(
        _ selectedConditions: Set<SelectableConfirmationCondition>
    ) -> Observable<Bool> {
        Observable.just(essentialConditions.isSubset(of: selectedConditions))
    }
    
    public func isNicknameInputValid(_ input: String) -> Observable<NicknameInputStatus> {
        nicknameUseCase.checkNicknameValidation(for: input)
    }
    
    public func isBirthdayInputValid(_ input: String) -> Observable<NicknameInputStatus> {
   
        let isEmpty = input.isEmpty
        let isValid = getBirthdayInputValidation(input)
        let status: NicknameInputStatus.Status = isEmpty ? .impossible(description: "생년월일을 입력해주세요") :
                                                 isValid ? .possible(description: "") :
                                                           .impossible(description: "생년월일을 입력해주세요")
        
        return Observable.just(.init(isValid: isValid, status: status))
    }
    
    private func getBirthdayInputValidation(_ input: String) -> Bool {
        guard input.count == 6 else { return false }
            
        let numbersSet = CharacterSet.decimalDigits
        let inputCharacterSet = CharacterSet(charactersIn: input)
        
        return inputCharacterSet.isSubset(of: numbersSet)
    }
}
