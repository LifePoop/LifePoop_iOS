//
//  ProfileViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/21.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureSettingCoordinatorInterface
import FeatureSettingDIContainer
import FeatureSettingUseCase
import SharedDIContainer
import SharedUseCase
import Utils

public final class ProfileViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let nicknameDidChange = PublishRelay<String>()
        let profileCharacterEditDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let setProfileCharater = PublishRelay<ProfileCharacter>()
        let userNickName = BehaviorRelay<String>(value: "")
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let profileCharacter = BehaviorRelay<ProfileCharacter?>(value: nil)
        let userNickname: BehaviorRelay<String>
    }
    
    public let input = Input()
    public let output = Output()
    public let state: State
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    @Inject(SharedDIContainer.shared) private var profileCharacterUseCase: ProfileCharacterUseCase
    
    public init(coordinator: SettingCoordinator?, userNickname: BehaviorRelay<String>) {
        self.coordinator = coordinator
        self.state = State(userNickname: userNickname)
        
        let userProfileCharacter = input.viewDidLoad
            .withUnretained(self)
            .flatMap { `self`, _ in
                self.profileCharacterUseCase.profileCharacter
            }
            .share()
        
        userProfileCharacter
            .filter { $0 == nil }
            .map { _ in ProfileCharacter(color: .brown, stiffness: .normal) }
            .bind(to: state.profileCharacter)
            .disposed(by: disposeBag)
        
        userProfileCharacter
            .bind(to: state.profileCharacter)
            .disposed(by: disposeBag)
        
        input.nicknameDidChange // TODO: Execute UseCase, TextField textChanged 처리
        
        input.profileCharacterEditDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(by: .profileCharacterEditDidTap(profileCharacter: self.state.profileCharacter))
            }
            .disposed(by: disposeBag)
        
        state.userNickname
            .bind(to: output.userNickName)
            .disposed(by: disposeBag)
        
        state.profileCharacter
            .compactMap { $0 }
            .bind(to: output.setProfileCharater)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("\(self) \(#function)") // FIXME: Import Logger
    }
}
