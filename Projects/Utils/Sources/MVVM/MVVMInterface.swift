//
//  MVVMInterface.swift
//  Utils
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import Foundation

public protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

public protocol ViewType: AnyObject {
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel? { get set }
    
    func bindInput(to viewModel: ViewModel)
    func bindOutput(from viewModel: ViewModel)
}

public extension ViewType {
    func bind(viewModel: ViewModel) {
        self.viewModel = viewModel
        bindOutput(from: viewModel)
        bindInput(to: viewModel)
    }
}
