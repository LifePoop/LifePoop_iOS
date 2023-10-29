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

    /** 사용자 입력 회원가입 정보로 서버에 새로운 회원정보 추가 요청 **/
    func requestSignup(_ signupInfo: SignupInput) -> Observable<Bool>
    func fetchSelectableConditions() -> Observable<[AgreementCondition]>
    func isNicknameInputValid(_ input: String) -> Observable<NicknameTextInput>
    func isBirthdayInputValid(_ input: String) -> Observable<BirthdayTextInput>
    func createFormattedDateString(with dateString: String) -> String?
    func isAllEsssentialConditionsSelected(_ selectedConditions: Set<AgreementCondition>) -> Observable<Bool>
}
