//
//  NameInputViewModel.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NameInputViewModel: BaseViewModel {
    
    struct Input {
        let nameInput: Observable<String>
        let nextTap: Observable<Void>
    }

    struct Output {
        let isValidName: Driver<Bool>
        let navigateToNext: Signal<String>
    }

    private let currentName = BehaviorRelay<String>(value: "")
    
    func transform(input: Input) -> Output {
        input.nameInput
            .bind(to: currentName)
            .disposed(by: disposeBag)
        
        let isValidName = currentName
            .map { name in
                let regex = "^[a-zA-Z가-힣]{2,10}$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: name)
            }
            .asDriver(onErrorJustReturn: false)
        
        let navigateToNext = input.nextTap
            .withLatestFrom(currentName)
            .asSignal(onErrorJustReturn: "")
        
        return Output(isValidName: isValidName, navigateToNext: navigateToNext)
    }
}
