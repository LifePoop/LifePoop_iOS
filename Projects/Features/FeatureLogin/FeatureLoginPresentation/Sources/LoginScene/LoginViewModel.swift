//
//  LoginViewModel.swift
//  FeatureLoginPresentation
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureLoginCoordinatorInterface
import FeatureLoginDIContainer
import FeatureLoginUseCase
import Utils

public final class LoginViewModel: ViewModelType {
    
    public struct Input {
        let didTapKakaoLoginButton = PublishRelay<Void>()
        let didTapAppleLoginButton = PublishRelay<Void>()
        let didChangeBannerImageIndex = PublishRelay<Int>()
    }
    
    public struct Output {
        let bannerImages = BehaviorRelay<[Data]>(value: [])
        let subLabelText = BehaviorRelay<String>(value: "나의 변을 기록하고")
        let showErrorMessage = PublishRelay<String>()
    }
    
    public let input = Input()
    public let output = Output()
    
    @Inject(LoginDIContainer.shared) private var loginUseCase: LoginUseCase
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        let fetchKakaoToken = input.didTapKakaoLoginButton
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                `self`.loginUseCase.fetchUserAuthInfo(for: .kakao)
            }
            .share()
        
        fetchKakaoToken
            .compactMap { $0.element }
            .compactMap { $0 }
            .bind(onNext: { coordinator?.coordinate(by: .didTapKakaoLoginButton(userAuthInfo: $0)) })
            .disposed(by: disposeBag)
        
        fetchKakaoToken
            .compactMap { $0.error }
            .map { $0.localizedDescription }
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let fetchAppleToken = input.didTapAppleLoginButton
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                `self`.loginUseCase.fetchUserAuthInfo(for: .apple)
            }
            .share()
        
        fetchAppleToken
            .compactMap { $0.element }
            .compactMap { $0 }
            .bind {
                coordinator?.coordinate(
                    by: .didTapAppleLoginButton(userAuthInfo: $0)
                )
            }
            .disposed(by: disposeBag)
        
        fetchAppleToken
            .compactMap { $0.error }
            .map { $0.localizedDescription }
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
   
        input.didChangeBannerImageIndex
            .compactMap {
                switch $0 {
                case 0: return "나의 변을 기록하고"
                case 1: return "서로의 변을 응원하고"
                case 2: return "배변일지를 공유받자!"
                default: return nil
                }
            }
            .bind(to: output.subLabelText)
            .disposed(by: disposeBag)
    }
}
