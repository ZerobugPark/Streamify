//
//  DramaViewModel.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DramaViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let sectionModel: Driver<[DramaSectionModel]>
    }
    
    func transform(input: BaseViewModel.Input) -> Output {
        let sectionModel = BehaviorRelay<[DramaSectionModel]>(value: [])
        
        
        
        return Output(sectionModel: sectionModel.asDriver())
    }
    
}
