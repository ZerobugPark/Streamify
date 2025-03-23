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
    case firstSection(Int)
    case secondSection(Int)
    case thirdSection(Int)
}

enum CollectionViewSectionModel { //섹션 정의
    case first(header: String ,[SectionItem])
    case second(header: String,[SectionItem])
    case third(header: String, [SectionItem])
    
}

extension CollectionViewSectionModel: SectionModelType {
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .first(_, let items):
            return items
        case .second(_, let items):
            return items
        case .third(_, let items):
            return items
        }
    }
    
    
    var header: String {
        switch self {
        case .first(let header, _):
            return header
        case .second(let header, _):
            return header
        case .third(let header, _):
            return header
        }
    }

    init(original: CollectionViewSectionModel, items: [Self.Item]) {
        self = original
        
    }
}


final class StorageViewModel: BaseViewModel {
    
    struct Input {
        let setInitialData: Observable<()>
        let actionButtonTapped: Observable<ActionButtonStatus>
    }
    
    struct Output {
        let setSetcion: BehaviorRelay<[CollectionViewSectionModel]>
        let buttonTogle: PublishRelay<ActionButtonStatus>
        let goToStarRating: PublishRelay<Void>
        let goToComment: PublishRelay<Void>
    }
    
    
    
    
    let firstValue: [SectionItem] = [
        .firstSection(1),
        .firstSection(2),
        .firstSection(3)
    ]

    let secondValue: [SectionItem] = [
        .secondSection(4),
        .secondSection(5)
    ]

    let thirdValue: [SectionItem] = [
        .thirdSection(6),
        .thirdSection(7),
        .thirdSection(8),
        .thirdSection(9)
    ]
    
    private let emptySection: [SectionItem] = []

    private var previousStatus: ActionButtonStatus = .all
    
    func transform(input: Input) -> Output {
        
        let title = ["내가 찜한 리스트", "내가 본 콘텐츠", "시청 중인 콘텐츠", ""]
        
        let sectiomModel = BehaviorRelay<[CollectionViewSectionModel]>(value: [.first(header: title[0], firstValue), .second(header: title[1], secondValue), .third(header: title[2], thirdValue)])
        
        let buttonToggle = PublishRelay<ActionButtonStatus>()
        let goToStarRating = PublishRelay<Void>()
        let goToComment = PublishRelay<Void>()
                
        input.actionButtonTapped.bind(with: self) { owner, tag in
            
            if owner.previousStatus == tag {
                
                sectiomModel.accept([.first(header: title[0], owner.firstValue), .second(header: title[1], owner.secondValue), .third(header: title[2], owner.thirdValue)])
                buttonToggle.accept(.all)
                
                owner.previousStatus = .all
                return
            }
            
            switch tag {
            case .wantToWatchButton:
                sectiomModel.accept([.first(header: title[0], owner.firstValue), .second(header: title[3], owner.emptySection), .third(header: title[3], owner.emptySection)])
                buttonToggle.accept(.wantToWatchButton)
            case .watchedButton:
                sectiomModel.accept([.first(header: title[1], owner.secondValue), .second(header: title[3], owner.emptySection), .third(header: title[3], owner.emptySection)])
                buttonToggle.accept(.watchedButton)
            case .watchingButton:
                sectiomModel.accept([.first(header: title[2], owner.thirdValue), .second(header: title[3], owner.emptySection), .third(header: title[3], owner.emptySection)])
                buttonToggle.accept(.watchingButton)
            case .commentButton:
                goToComment.accept(())
                return
            case .ratingButton:
                goToStarRating.accept(())
                return
            case .all:
                break
            }
            
            owner.previousStatus = tag
            
        }.disposed(by: disposeBag)
        
        return Output(setSetcion: sectiomModel, buttonTogle: buttonToggle, goToStarRating: goToStarRating, goToComment: goToComment)
    }
    
    
}
