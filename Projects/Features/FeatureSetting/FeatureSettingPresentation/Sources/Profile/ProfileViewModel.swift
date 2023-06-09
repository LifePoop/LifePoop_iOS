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
        let profileCharacterDidChange = PublishRelay<ProfileCharacter>()
        let editConfirmDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let setProfileCharater = PublishRelay<ProfileCharacter>()
        let setUserNickname = PublishRelay<String>()
        let changeTextFieldStatus = PublishRelay<NicknameInputStatus.Status>()
        let enableEditConfirmButton = PublishRelay<Bool>()
        let showToastMessage = PublishRelay<String>()
    }
    
    public struct State {
        let profileCharacter = BehaviorRelay<ProfileCharacter?>(value: nil)
        let userNickname: BehaviorRelay<String?>
        let changedProfileCharacter = BehaviorRelay<ProfileCharacter?>(value: nil)
        let changedUserNickname = BehaviorRelay<String?>(value: nil)
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
        
        // MARK: - Bind Input
        
        let userProfileCharacter = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.profileCharacterUseCase.profileCharacter
            }
            .share()
        
        userProfileCharacter
            .compactMap { $0.error }
            .toastMeessageMap(to: .setting(.failToChangeProfileCharacter))
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        userProfileCharacter
            .compactMap { $0.element }
            .bind(to: state.profileCharacter, state.changedProfileCharacter)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withLatestFrom(state.userNickname)
            .compactMap { $0 }
            .bind(to: output.setUserNickname)
            .disposed(by: disposeBag)
        
        // FIXME: 서버에서 유저 생성시 기본 캐릭터 설정해줄 경우 불필요함 - 삭제하기
        /// 아직 프로필 캐릭터를 설정하지 않은 유저에 대해 디폴트 캐릭터 설정하는 코드
        /// - 이렇게 '프로필 정보 수정 화면에 진입할 때' nil인지 확인해서 디폴트 캐릭터를 설정할 것인지,
        /// - 아니면 '초기에 사용자가 계정을 생성할 때' 디폴트 캐릭터를 설정해 줄 것인지는 추후 결정
        // input.viewDidLoad
        //     .withLatestFrom(state.profileCharacter)
        //     .filter { $0 == nil }
        //     .map { _ in ProfileCharacter(color: .brown, shape: .good) }
        //     .withUnretained(self)
        //     .flatMapCompletableMaterialized { `self`, profileCharacter in
        //         self.profileCharacterUseCase.updateProfileCharacter(to: profileCharacter)
        //     }
        //     .filter { $0.isCompleted }
        //     .map { _ in ProfileCharacter(color: .brown, shape: .good) }
        //     .bind(to: state.profileCharacter)
        //     .disposed(by: disposeBag)
        
        input.nicknameDidChange
            .skip(1)
            .bind(to: state.changedUserNickname)
            .disposed(by: disposeBag)
        
        input.profileCharacterEditDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                coordinator?.coordinate(
                    by: .profileCharacterEditDidTap(profileCharacter: self.state.changedProfileCharacter)
                )
            }
            .disposed(by: disposeBag)
        
        // TODO: Loding Indicator 로직 구현
        
        input.editConfirmDidTap
            .withLatestFrom(state.changedUserNickname)
            .bind(to: state.userNickname)
            .disposed(by: disposeBag)
        
        let nicknameChangeResult = input.editConfirmDidTap
            .withLatestFrom(state.changedUserNickname)
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, newNickname in
                self.nicknameUseCase.updateNickname(to: newNickname)
            }
            .share()
        
        nicknameChangeResult
            .compactMap { $0.error }
            .toastMeessageMap(to: .setting(.failToChangeNickname))
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        let profileCharacterChangeResult = input.editConfirmDidTap
            .withLatestFrom(state.changedProfileCharacter)
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, profileCharacter in
                self.profileCharacterUseCase.updateProfileCharacter(to: profileCharacter)
            }
            .share()
        
        profileCharacterChangeResult
            .compactMap { $0.error }
            .toastMeessageMap(to: .setting(.failToChangeProfileCharacter))
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        // TODO: Update Complete Action 구현
        
        // MARK: - Bind State
        
        state.changedProfileCharacter
            .compactMap { $0 }
            .bind(to: output.setProfileCharater)
            .disposed(by: disposeBag)
        
        state.changedUserNickname
            .compactMap { $0 }
            .withLatestFrom(state.userNickname.compactMap { $0 }) {
                (changedNickname: $0, initialNickname: $1)
            }
            .filter { $0 == $1 }
            .map { _ in .default }
            .bind(to: output.changeTextFieldStatus)
            .disposed(by: disposeBag)
        
        let nicknameValidation = state.changedUserNickname
            .compactMap { $0 }
            .withLatestFrom(state.userNickname.compactMap { $0 }) {
                (changedNickname: $0, initialNickname: $1)
            }
            .filter { $0 != $1 }
            .map { $0.changedNickname }
            .withUnretained(self)
            .flatMap { `self`, changedNickname in
                self.nicknameUseCase.checkNicknameValidation(for: changedNickname)
            }
            .map { $0.status }
            .share()
        
        nicknameValidation
            .bind(to: output.changeTextFieldStatus)
            .disposed(by: disposeBag)
        
        let isNicknameValid = nicknameValidation
            .startWith(.default)
            .map { $0 != .impossible }
            .share()
        
        let isNicknameChanged = state.changedUserNickname
            .withLatestFrom(state.userNickname.compactMap { $0 }) {
                (changedNickname: $0, initialNickname: $1)
            }
            .map { $0.changedNickname != $0.initialNickname }
            .share()
        
        let isProfileCharacterChanged = state.changedProfileCharacter
            .withLatestFrom(state.profileCharacter.compactMap { $0 }) {
                (changedProfileCharacter: $0, initialProfileCharacter: $1)
            }
            .map { $0.changedProfileCharacter != $0.initialProfileCharacter }
            .share()
        
        Observable.combineLatest(isNicknameValid, isNicknameChanged, isProfileCharacterChanged)
            .map { $0 && ($1 || $2) }
            .bind(to: output.enableEditConfirmButton)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("\(self) \(#function)") // FIXME: Import Logger
    }
}
