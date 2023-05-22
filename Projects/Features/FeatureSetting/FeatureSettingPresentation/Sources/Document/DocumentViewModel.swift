//
//  DocumentViewModel.swift
//  FeatureSettingPresentation
//
//  Created by 김상혁 on 2023/05/17.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

import RxRelay
import RxSwift

import Utils

public final class DocumentViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    public struct Output {
        let title = BehaviorRelay<String>(value: "")
        let documentText = BehaviorRelay<String>(value: "")
    }
    
    public let input = Input()
    public let output = Output()
    
    private let disposeBag = DisposeBag()
    
    public init(documentType: DocumentType) {
        input.viewDidLoad
            .compactMap { Bundle.utils?.text(from: documentType.textFile) }
            .bind(to: output.documentText)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { documentType.title }
            .bind(to: output.title)
            .disposed(by: disposeBag)
    }
}
