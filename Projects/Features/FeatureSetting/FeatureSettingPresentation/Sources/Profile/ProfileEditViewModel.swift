//
//  ProfileEditViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/29.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureSettingCoordinatorInterface
import SharedDIContainer
import SharedUseCase
import Utils

public final class ProfileEditViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let profileCharacterColorDidSelect = PublishRelay<SelectableColor>()
        let profileCharacterStiffnessDidSelect = PublishRelay<SelectableStiffness>()
        let confirmButtonDidTap = PublishRelay<Void>()
    }
    
    public struct Output {
        let selectProfileCharacterColor = PublishRelay<SelectableColor>()
        let selectProfileCharacterStiffness = PublishRelay<SelectableStiffness>()
        let showErrorMessage = PublishRelay<String>()
    }
    
    public struct State {
        let profileCharacter: BehaviorRelay<ProfileCharacter?>
    }
    
    public let input = Input()
    public let output = Output()
    public let state: State
    
    @Inject(SharedDIContainer.shared) private var profileCharacterUseCase: ProfileCharacterUseCase
    
    private weak var coordinator: SettingCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingCoordinator?, profileCharacter: BehaviorRelay<ProfileCharacter?>) {
        self.coordinator = coordinator
        self.state = State(profileCharacter: profileCharacter)
        
        input.viewDidLoad
            .withLatestFrom(state.profileCharacter)
            .compactMap { $0?.stiffness }
            .bind(to: output.selectProfileCharacterStiffness)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withLatestFrom(state.profileCharacter)
            .compactMap { $0?.color }
            .bind(to: output.selectProfileCharacterColor)
            .disposed(by: disposeBag)
        
        let latestCharacterAttributes = Observable
            .combineLatest(
                input.profileCharacterColorDidSelect,
                input.profileCharacterStiffnessDidSelect
            )
            .share()
        
        input.confirmButtonDidTap
            .withLatestFrom(latestCharacterAttributes)
            .map { (color, stiffness) -> ProfileCharacter in
                ProfileCharacter(color: color, stiffness: stiffness)
            }
            .bind(to: state.profileCharacter)
            .disposed(by: disposeBag)
        
        state.profileCharacter
            .compactMap { $0 }
            .withUnretained(self)
            .bind { `self`, profileCharacter in
                self.profileCharacterUseCase.updateProfileCharacter(to: profileCharacter)
            }
            .disposed(by: disposeBag)
    }
}
