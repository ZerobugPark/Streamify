//
//  MainViewModel.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {

    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()

    // MARK: - Output
    let topRatedItems = BehaviorRelay<[TopRatedResult]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<String>()

    private let disposeBag = DisposeBag()

    init() {
        bind()
    }

    private func bind() {
        viewDidLoad
            .do(onNext: { [weak self] in self?.isLoading.accept(true) })
            .flatMapLatest {
                NetworkManager.shared
                    .request(api: .topRated, type: TMDBResponse.self)
                    .asObservable()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.isLoading.accept(false)
                switch result {
                case .success(let response):
                    self.topRatedItems.accept(response.results)
                case .failure(let apiError):
                    self.error.accept(apiError.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}
