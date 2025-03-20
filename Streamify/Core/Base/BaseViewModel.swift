//
//  BaseViewModel.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: ViewModelType {
    
    typealias Input = Void
    typealias Output = Void
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output { return () }
    
}
