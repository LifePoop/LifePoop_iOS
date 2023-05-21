//
//  NicknameViewModel.swift
//  FeatureLoginPresentation
//
//  Created by 이준우 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import CoreEntity
import FeatureLoginCoordinatorInterface
import Utils

public final class NicknameViewModel: ViewModelType {

    enum TextFieldStatus {
        case possible(text: String)
        case impossible(text: String)
        case none(text: String)
    }

    public struct Input {
        let didTapNextButton = PublishRelay<Void>()
        let didEnterTextValue = PublishRelay<String>()
        let didSelectConfirmCondition = PublishRelay<SelectableConfirmationCondition>()
        let didDeselectConfirmCondition = PublishRelay<SelectableConfirmationCondition>()
        let didSelectAllEssentialConditions = PublishRelay<Bool>()
        let didTapLeftBarbutton = PublishRelay<Void>()
        let viewDidLoad = PublishRelay<Void>()
    }
    
    public struct Output {
        let textFieldStatus = BehaviorRelay<TextFieldStatus>(value: .none(text: "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다."))
        let selectableConditions = BehaviorRelay<[SelectableConfirmationCondition]>(value: [])
        let activateNextButton = BehaviorRelay<Bool>(value: false)
        let selectAllConditions = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()

    private var selectedConditions: Set<SelectableConfirmationCondition> = [] {
        didSet {
            // TODO: 바인딩 메소드로 이동시키고, 유효성 판단 여부는 UseCase로 이동시켜도 될 지 다시 확인해야 함
            input.didSelectAllEssentialConditions.accept(
                essentialConditions.isSubset(of: selectedConditions)
            )
        }
    }
    private var essentialConditions: Set<SelectableConfirmationCondition> = []
    
    // TODO: Repository -> UseCase 순서로 거쳐오도록 수정해야 함
    private let conditionEntities: [SelectableConfirmationCondition] = [
        .init(
            descriptionText: "전체동의",
            descriptionTextSize: .large,
            detailTerms: nil,
            selectionType: .selectAll
        ),
        .init(
            descriptionText: "만 14세 이상입니다.(필수)",
            descriptionTextSize: .normal,
            detailTerms: "",
            selectionType: .essential
        ),
        .init(
            descriptionText: "서비스 이용 약관 (필수)",
            descriptionTextSize: .normal,
            detailTerms: "",
            selectionType: .essential
        ),
        .init(
            descriptionText: "개인정보 수집 및 이용 (필수)",
            descriptionTextSize: .normal,
            detailTerms: "",
            selectionType: .essential
        ),
        .init(
            descriptionText: "이벤트, 프로모션 알림 메일 수신 (선택)",
            descriptionTextSize: .normal,
            detailTerms: nil,
            selectionType: .optional
        )
    ]

    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        bind()
    }
    
    private func bind() {
        guard let coordinator = self.coordinator else { return }
                
        input.didTapNextButton
            .bind(onNext: { _ in
                coordinator.coordinate(by: .didTapNicknameSetButton)
            })
            .disposed(by: disposeBag)
        
        input.didTapLeftBarbutton
            .bind(onNext: { _ in
                coordinator.coordinate(by: .shouldPopCurrentScene)
            })
            .disposed(by: disposeBag)
        
        input.didSelectConfirmCondition
            .withUnretained(self)
            .bind(onNext: { owner, condition in
                switch condition.selectionType {
                case .selectAll:
                    owner.output.selectAllConditions.accept(true)
                default:
                    owner.selectedConditions.insert(condition)
                }
            })
            .disposed(by: disposeBag)

        input.didDeselectConfirmCondition
            .withUnretained(self)
            .bind(onNext: { owner, condition in
                switch condition.selectionType {
                case .selectAll:
                    owner.output.selectAllConditions.accept(false)
                default:
                    owner.selectedConditions.remove(condition)
                }
            })
            .disposed(by: disposeBag)
        
        output.selectAllConditions
            .withLatestFrom(output.selectableConditions) {
                ($0, Set($1.filter { $0.selectionType != .selectAll }))
            }
            .map { $0 ? $1 : [] }
            .withUnretained(self)
            .bind(onNext: { owner, selectedConditions in
                owner.selectedConditions = selectedConditions
            })
            .disposed(by: disposeBag)

        // TODO: 텍스트 입력값 유효성 판단은 UseCase 내부로 이동해야 함
        let nicknameInputStatus = input.didEnterTextValue
            .map { text -> (isPossible: Bool, status: TextFieldStatus) in
                guard !text.isEmpty else { return (false, .none(text: "2~5자로 한글, 영문, 숫자를 사용할 수 있습니다.")) }

                let hasAnyBlank = text.contains(where: { $0.isWhitespace })
                let didExceedLimit = text.count < 2 || text.count > 5
                let isPossible = !hasAnyBlank && !didExceedLimit
                let status: TextFieldStatus =  isPossible ? .possible(text: "사용 가능한 닉네임이에요.") :
                                               hasAnyBlank ? .impossible(text: "공백을 포함할 수 없어요.") :
                                               didExceedLimit ? .impossible(text: "2~5글자 범위만 가능해요.") :
                                                                .impossible(text: "사용 불가능한 닉네임이에요.")
                
                return (isPossible, status)
            }
            .share()
        
        nicknameInputStatus
            .map { $0.status }
            .bind(to: output.textFieldStatus)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(input.didSelectAllEssentialConditions, nicknameInputStatus)
            .map { $0 && $1.isPossible }
            .bind(to: output.activateNextButton)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .compactMap { [weak self] _ in self?.conditionEntities }
            .do(onNext: { [weak self] in
                self?.essentialConditions = Set($0.filter { $0.selectionType == .essential })
            })
            .bind(to: output.selectableConditions)
            .disposed(by: disposeBag)
    }
}
