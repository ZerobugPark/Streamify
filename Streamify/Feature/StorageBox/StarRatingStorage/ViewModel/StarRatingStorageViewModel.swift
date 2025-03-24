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
        let setInitialData: Observable<[Rate]>
        
    }
    
    struct Output {
        let setRates: BehaviorRelay<[Rate]>
        
    }
    
    
    private var rates: [Rate] = []

    
    func transform(input: Input) -> Output {
      
        let setRates = BehaviorRelay(value: rates)
        
        input.setInitialData.bind(with: self) { owner, data in
            
            owner.rates = data
            setRates.accept(owner.rates)
            
        }.disposed(by: disposeBag)
        
        
        
        return Output(setRates: setRates)
    }
    
    
  
}
