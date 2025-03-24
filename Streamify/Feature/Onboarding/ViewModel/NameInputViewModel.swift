//
//  NameInputViewModel.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import Foundation
import RxSwift
import RxCocoa

class NameInputViewModel {
    let inputName = BehaviorRelay<String>(value: "")
    
    var isValidName: Driver<Bool> {
        return inputName
            .map { name in
                let regex = "^[a-zA-Z가-힣]{2,10}$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: name)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
