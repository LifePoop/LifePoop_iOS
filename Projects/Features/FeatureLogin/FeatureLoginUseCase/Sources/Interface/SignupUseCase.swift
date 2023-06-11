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
    
    func fetchSelectableConditions() -> Observable<[SelectableConfirmationCondition]>
    func isNicknameInputValid(_ input: String) -> Observable<NicknameInputStatus>
    func isBirthdayInputValid(_ input: String) -> Observable<NicknameInputStatus>
    func isAllEsssentialConditionsSelected(_ selectedConditions: Set<SelectableConfirmationCondition>) -> Observable<Bool>
}
