//
//  EpisodeCellViewModel.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class EpisodeCellViewModel: BaseViewModel {
    struct Input {
        
    }
    
    struct Output {
        let sectionModel: Driver<[EpisodeSectionModel]>
    }
    
    func transform(input: EpisodeCellViewModel.Input) -> Output {
        let sectionModel = BehaviorRelay<[EpisodeSectionModel]>(value: [])
        
        
        
        return Output(sectionModel: sectionModel.asDriver())
    }
    
}
