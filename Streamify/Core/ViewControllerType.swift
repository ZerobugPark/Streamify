//
//  ViewControllerType.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import Foundation
import RxSwift

protocol ViewControllerType {
    associatedtype ViewModelType
    var viewModel: ViewModelType { get }
    var disposeBag: DisposeBag { get }
    
    func bindViewModel()
}

