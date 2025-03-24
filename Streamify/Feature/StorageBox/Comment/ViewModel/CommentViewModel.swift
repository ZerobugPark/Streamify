//
//  CommentViewModel.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import Foundation

import RxCocoa
import RxSwift

final class CommentViewModel: BaseViewModel {
  
    struct Input {
        let setInitialData: Observable<[Comments]>
        
    }
    
    struct Output {
        let setComments: BehaviorRelay<[Comments]>
        
    }
    
    
    private var originComments: [Comments] = []
    private var filterComments: [Comments] = []

    
    func transform(input: Input) -> Output {
      
        let setComments = BehaviorRelay(value: filterComments)
        
        input.setInitialData.bind(with: self) { owner, data in
            
            owner.originComments = data
            owner.filterComments = data
            
            setComments.accept(owner.filterComments)
            
            
        }.disposed(by: disposeBag)
        
        
        
        return Output(setComments: setComments)
    }
}
