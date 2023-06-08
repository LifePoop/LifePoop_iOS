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
        let changeConfirmDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let setProfileCharater = PublishRelay<ProfileCharacter>()
        let setUserNickname = PublishRelay<String>()
        let enableChangeConfirmButton = PublishRelay<Bool>()
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
        
        /// 아직 프로필 캐릭터를 설정하지 않은 유저에 대해 디폴트 캐릭터 설정하는 코드
        /// - 이렇게 '프로필 정보 수정 화면에 진입할 때' nil인지 확인해서 디폴트 캐릭터를 설정할 것인지,
        /// - 아니면 '초기에 사용자가 계정을 생성할 때' 디폴트 캐릭터를 설정해 줄 것인지는 추후 결정
        input.viewDidLoad
            .withLatestFrom(state.profileCharacter)
            .filter { $0 == nil }
            .map { _ in ProfileCharacter(color: .brown, shape: .good) }
            .bind(to: state.profileCharacter)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withLatestFrom(state.userNickname)
            .compactMap { $0 }
            .bind(to: output.setUserNickname)
            .disposed(by: disposeBag)
        
        input.changeConfirmDidTap
            .withLatestFrom(input.nicknameDidChange)
            .bind(to: state.userNickname)
            .disposed(by: disposeBag)
        
        input.nicknameDidChange // TODO: NicknameViewModel의 로직을 UseCase로 분리해서 사용
        
        input.profileCharacterEditDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(by: .profileCharacterEditDidTap(profileCharacter: self.state.profileCharacter))
            }
            .disposed(by: disposeBag)
        
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
        
        // FIXME: input.changeConfirmDidTap로 바인딩하기
        state.profileCharacter
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, profileCharacter in
                self.profileCharacterUseCase.updateProfileCharacter(to: profileCharacter)
            }
            .compactMap { $0.error }
            .toastMeessageMap(to: .setting(.failToChangeProfileCharacter))
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("\(self) \(#function)") // FIXME: Import Logger
    }
}
