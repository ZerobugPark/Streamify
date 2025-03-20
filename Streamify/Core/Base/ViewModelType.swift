//
//  ViewModelType.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
