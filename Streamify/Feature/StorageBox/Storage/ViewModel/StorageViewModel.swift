//
//  StorageViewModel.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import Foundation

import RxCocoa
import RxDataSources
import RxSwift

enum SectionItem { //셀의 종류
    case firstSection([Int])
    case secondSection([Int])
    case thirdSection([Int])
}

enum CollectionViewSectionModel { //섹션 정의
    case first([SectionItem])
    case second([SectionItem])
    case third([SectionItem])
    
}

extension CollectionViewSectionModel: SectionModelType {
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .first(let items):
            return items
        case .second(let items):
            return items
        case .third(let items):
            return items
        }
    }
    
    
    init(original: CollectionViewSectionModel, items: [Self.Item]) {
        self = original
        
    }
}


final class StorageViewModel: BaseViewModel {
    
    struct Input {
        let setInitialData: Observable<()>
    }
    
    struct Output {
        let test: Observable<[CollectionViewSectionModel]>
    }
    
    
    let firstValue = Array(1...100)
    let secondValue = Array(1...100)
    let thirdValue = Array(1...100)
    

    
    
    func transform(input: Input) -> Output {
        
        lazy var sectiomModel: Observable<[CollectionViewSectionModel]> = Observable.just([
            .first(firstValue.map { .firstSection([$0]) }),
            .second(secondValue.map { .secondSection([$0]) }),
            .third(thirdValue.map { .thirdSection([$0]) }),
        ])
        
        return Output(test: sectiomModel)
    }
    
    
}
