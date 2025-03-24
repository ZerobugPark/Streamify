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
    
    private let dramaID: Int
    
    init(dramaID: Int) {
        self.dramaID = dramaID
    }
    
    struct Input {
        
    }
    
    struct Output {
        let sectionModel: Driver<[DramaSectionModel]>
    }
    
    func transform(input: DramaViewModel.Input) -> Output {
        let sectionModel = BehaviorRelay<[DramaSectionModel]>(value: [])
        
        // TODO: DramaID로 실제 API CALL 필요
        print("Fetch drama detail for ID: \(dramaID)")
        
        return Output(sectionModel: sectionModel.asDriver())
    }
    
}
