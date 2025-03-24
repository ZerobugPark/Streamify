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
        let filterButtonStatus: Observable<Bool>
    }
    
    struct Output {
        let setRates: BehaviorRelay<[Rate]>
        let filterButtonToggle: PublishRelay<Void>
    }
    
    
    private var rates: [Rate] = []

    
    func transform(input: Input) -> Output {
      
        let setRates = BehaviorRelay(value: rates)
        let filterButtonToggle = PublishRelay<Void>()
        
        input.setInitialData.bind(with: self) { owner, data in
            
            owner.rates = data
            owner.rates = owner.filterData(data)
            
            setRates.accept(owner.rates)
            
        }.disposed(by: disposeBag)
        
        input.filterButtonStatus.bind(with: self) { owner, status in
            
            if status {
                owner.rates = owner.filterData(owner.rates, status: status)
                
            } else {
                owner.rates = owner.filterData(owner.rates, status: status)
            }
            setRates.accept(owner.rates)
            filterButtonToggle.accept(())
            
            
        }.disposed(by: disposeBag)
        
 
        return Output(setRates: setRates, filterButtonToggle: filterButtonToggle)
    }
    

}

extension StarRatingStorageViewModel {
    
    private func filterData(_ data: [Rate], status: Bool = true) -> [Rate] {
        
        if status {
            let filterData = rates.sorted { $0.voteAverage > $1.voteAverage }
            return filterData
        } else {
            let filterData = rates.sorted { $0.voteAverage < $1.voteAverage }
            return filterData
        }
        
        
    }
}
