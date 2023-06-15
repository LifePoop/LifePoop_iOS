//
//  DefaultNicknameUseCase.swift
//  SharedUseCase
//
//  Created by 김상혁 on 2023/05/27.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import Logger
import SharedDIContainer
import Utils

public final class DefaultNicknameUseCase: NicknameUseCase {
    
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    
    public init() { }
    
    public var nickname: Observable<String?> {
        return userDefaultsRepository
            .getValue(for: .userNickname)
            .logErrorIfDetected(category: .userDefaults)
            .asObservable()
    }
    
    public func updateNickname(to newNickname: String) -> Completable {
        return userDefaultsRepository
            .updateValue(for: .isAutoLoginActivated, with: newNickname)
            .logErrorIfDetected(category: .userDefaults)
    }
    
    public func checkNicknameValidation(for input: String) -> Observable<NicknameInputStatus> {
        Observable.zip(
            hasAnyBlank(input: input),
            didExceedLimit(input: input),
            constainsAnyInvalidCharacters(input: input),
            isEmpty(input: input)
        )
        .map {
            let isValid =  !($0 || $1 || $2 || $3)
            let isEmpty = $3
            let status: NicknameInputStatus.Status = isEmpty  ? .impossible(description: "닉네임을 입력해주세요")
                                                     :isValid ? .possible(description: "사용 가능한 닉네임이에요")
                                                              : .impossible(description: "사용 불가능한 닉네임이에요")
            return NicknameInputStatus(isValid: isValid, status: status)
        }
    }
}

private extension DefaultNicknameUseCase {
    
    func isEmpty(input text: String) -> Observable<Bool> {
        Observable.just(text.isEmpty)
    }
 
    func hasAnyBlank(input text: String) -> Observable<Bool> {
        Observable.just(
            text.contains(where: { $0.isWhitespace })
        )
    }
    
    func didExceedLimit(input text: String) -> Observable<Bool> {
        Observable.just(
            text.count < 2 || text.count > 5
        )
    }
    
    func constainsAnyInvalidCharacters(input text: String) -> Observable<Bool> {
        let pattern = "^[가-힣a-zA-Z0-9]{2,5}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        
        let isInvalid = regex?.firstMatch(in: text, options: [], range: range) == nil
        return Observable.just(isInvalid)
    }
}
