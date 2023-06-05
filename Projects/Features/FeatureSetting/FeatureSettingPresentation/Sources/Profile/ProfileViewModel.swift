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
        let nicknameChangeConfirmDidTap = PublishRelay<Void>()
        let profileCharacterEditDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let setProfileCharater = PublishRelay<ProfileCharacter>()
        let setUserNickname = PublishRelay<String>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let profileCharacter = BehaviorRelay<ProfileCharacter?>(value: nil)
        let userNickname: BehaviorRelay<String?>
    }
    
    public let input = Input()
    public let output = Output()
    public let state: State
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    @Inject(SharedDIContainer.shared) private var nicknameUseCase: NicknameUseCase
    @Inject(SharedDIContainer.shared) private var profileCharacterUseCase: ProfileCharacterUseCase
    
    public init(coordinator: SettingCoordinator?, userNickname: BehaviorRelay<String?>) {
        self.coordinator = coordinator
        self.state = State(userNickname: userNickname)
        
        let userProfileCharacter = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.profileCharacterUseCase.profileCharacter
            }
            .share()
        
        userProfileCharacter
            .compactMap { $0.error }
            .toastMeessageMap(to: .setting(.failToChangeProfileCharacter))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
            
        userProfileCharacter
            .compactMap { $0.element }
            .bind(to: state.profileCharacter)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withLatestFrom(state.userNickname)
            .compactMap { $0 }
            .bind(to: output.setUserNickname)
            .disposed(by: disposeBag)
        
        input.nicknameChangeConfirmDidTap
            .withLatestFrom(input.nicknameDidChange) // TODO: nicknameDidChange binding
            .bind(to: state.userNickname)
            .disposed(by: disposeBag)
        
        input.profileCharacterEditDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(by: .profileCharacterEditDidTap(profileCharacter: self.state.profileCharacter))
            }
            .disposed(by: disposeBag)
        
        state.profileCharacter
            .filter { $0 == nil }
            .map { _ in ProfileCharacter(color: .brown, stiffness: .normal) }
            
        
        state.userNickname
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, newNickname in
                self.nicknameUseCase.updateNickname(to: newNickname)
            }
            .compactMap { $0.error }
            .toastMeessageMap(to: .setting(.failToChangeNickname))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        state.userNickname
            .compactMap { $0 }
            .bind(to: output.setUserNickname)
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
