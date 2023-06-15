//
//  ReportViewModel.swift
//  FeatureReportPresentation
//
//  Created by 김상혁 on 2023/06/08.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import RxRelay
import RxSwift

import CoreEntity
import FeatureReportCoordinatorInterface
import FeatureReportDIContainer
import FeatureReportUseCase
import Utils

public final class ReportViewModel: ViewModelType {
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    public struct Output {
        let showErrorMessage = PublishRelay<String>()
    }
    
    public let input = Input()
    public let output = Output()
    
    private weak var coordinator: ReportCoordinator?
    private let disposeBag = DisposeBag()
    
    public init(coordinator: ReportCoordinator?) {
        self.coordinator = coordinator
    }
}
