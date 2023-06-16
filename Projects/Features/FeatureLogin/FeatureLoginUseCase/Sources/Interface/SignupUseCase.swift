//
//  SignupUseCase.swift
//  FeatureLoginUseCase
//
//  Created by Lee, Joon Woo on 2023/06/10.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxSwift

import CoreEntity

public protocol SignupUseCase {
    
    func fetchSelectableConditions() -> Observable<[AgreementCondition]>
    func isNicknameInputValid(_ input: String) -> Observable<NicknameTextInput>
    func isBirthdayInputValid(_ input: String) -> Observable<BirthdayTextInput>
    func isAllEsssentialConditionsSelected(_ selectedConditions: Set<AgreementCondition>) -> Observable<Bool>
}
