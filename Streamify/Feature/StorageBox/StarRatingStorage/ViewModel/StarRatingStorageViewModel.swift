//
//  StarRatingStorageViewModel.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import Foundation

import RxCocoa
import RxDataSources
import RxSwift

final class StarRatingStorageViewModel: BaseViewModel {
    
    struct Input {
        let setInitialData: Observable<()>
        
    }
    
    struct Output {
        let setInitialData: BehaviorRelay<[Drama]>
        
    }
    
    
    private var drams: [Drama] = []
    

    
    override init() {
        drams = generateMockData()
    }
    
    
    
    func transform(input: Input) -> Output {
      
        let setInitialData = BehaviorRelay(value: drams)
        
        return Output(setInitialData: setInitialData)
    }
    
    
  
}
