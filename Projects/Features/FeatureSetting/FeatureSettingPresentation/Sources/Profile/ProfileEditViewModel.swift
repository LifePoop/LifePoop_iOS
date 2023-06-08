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
        let profileCharacterColorDidSelectAt = PublishRelay<Int>()
        let profileCharacterShapeDidSelectAt = PublishRelay<Int>()
    }
    
    public struct Output {
        let selectProfileCharacterColor = PublishRelay<StoolColor>()
        let selectProfileCharacterCharacter = PublishRelay<ProfileCharacter>()
        let enableConfirmButton = BehaviorRelay<Bool>(value: false)
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
            .compactMap { $0?.color }
            .bind(to: output.selectProfileCharacterColor)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withLatestFrom(state.profileCharacter)
            .compactMap { $0 }
            .bind(to: output.selectProfileCharacterCharacter)
            .disposed(by: disposeBag)
        
        input.profileCharacterColorDidSelectAt
            .compactMap { StoolColor(rawValue: $0) }
            .withLatestFrom(state.profileCharacter.compactMap { $0 }) {
                return (newColor: $0, shape: $1.shape)
            }
            .map { ProfileCharacter(color: $0, shape: $1)  }
            .bind(to: state.profileCharacter)
            .disposed(by: disposeBag)
        
        input.profileCharacterShapeDidSelectAt
            .compactMap { StoolShape(rawValue: $0) }
            .withLatestFrom(state.profileCharacter.compactMap { $0 }) {
                return (color: $1.color, newShape: $0)
            }
            .map { ProfileCharacter(color: $0, shape: $1)  }
            .bind(to: state.profileCharacter)
            .disposed(by: disposeBag)
        
        state.profileCharacter
            .compactMap { $0?.color }
            .bind(to: output.selectProfileCharacterColor)
            .disposed(by: disposeBag)
        
        state.profileCharacter
            .compactMap { $0 }
            .bind(to: output.selectProfileCharacterCharacter)
            .disposed(by: disposeBag)
    }
}
