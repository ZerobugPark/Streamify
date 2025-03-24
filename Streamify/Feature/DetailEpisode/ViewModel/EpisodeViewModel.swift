//
//  EpisodeViewModel.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class EpisodeViewModel: BaseViewModel {
    struct Input {
        
    }
    
    struct Output {
        let sectionModel: Driver<[EpisodeSectionModel]>
    }
    
    func transform(input: EpisodeViewModel.Input) -> Output {
        let sectionModel = BehaviorRelay<[EpisodeSectionModel]>(value: [])
        
        
        
        return Output(sectionModel: sectionModel.asDriver())
    }
    
}
