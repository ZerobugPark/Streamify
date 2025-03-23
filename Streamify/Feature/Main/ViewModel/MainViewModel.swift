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
    let trendingItems = BehaviorRelay<[TrendingResult]>(value: [])
    let similarItems = BehaviorRelay<[SimilarResult]>(value: [])
    let popularItems = BehaviorRelay<[PopularResult]>(value: [])
    let sectionModels = BehaviorRelay<[CollectionViewSectionModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<String>()

    private let disposeBag = DisposeBag()

    init() {
        bind()
    }

    private func bind() {
        viewDidLoad
            .do(onNext: { [weak self] in self?.isLoading.accept(true) })
            .flatMapLatest { [unowned self] in
                Observable.zip(
                    fetchTopRated(),
                    fetchTrending(),
                    fetchPopular()
                )
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] topRated, trending, popular in
                guard let self = self else { return }
                self.isLoading.accept(false)

                self.topRatedItems.accept(topRated)
                self.trendingItems.accept(trending)
                self.popularItems.accept(popular)

                let similarRequest = self.fetchSimilar(from: topRated.first?.id ?? 0)
                similarRequest
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { similar in
                        self.similarItems.accept(similar)

                        let models: [CollectionViewSectionModel] = [
                            .first(trending.map { .firstSection([$0.id]) }),
                            .second(similar.map { .secondSection([$0.id]) }),
                            .third(popular.map { .thirdSection([$0.id]) })
                        ]
                        self.sectionModels.accept(models)
                    })
                    .disposed(by: self.disposeBag)

            }, onError: { [weak self] err in
                self?.isLoading.accept(false)
                self?.error.accept("네트워크 오류: \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    private func fetchTopRated() -> Observable<[TopRatedResult]> {
        return NetworkManager.shared.request(api: .topRated, type: TMDBResponse.self)
            .map { result in
                switch result {
                case .success(let data): return data.results
                case .failure(let err): throw err
                }
            }
            .asObservable()
    }

    private func fetchTrending() -> Observable<[TrendingResult]> {
        return NetworkManager.shared.request(api: .trending, type: TMDBResponse.self)
            .map { result in
                switch result {
                case .success(let data): return data.results
                case .failure(let err): throw err
                }
            }
            .asObservable()
    }

    private func fetchPopular() -> Observable<[PopularResult]> {
        return NetworkManager.shared.request(api: .popular, type: TMDBResponse.self)
            .map { result in
                switch result {
                case .success(let data): return data.results
                case .failure(let err): throw err
                }
            }
            .asObservable()
    }

    private func fetchSimilar(from id: Int) -> Observable<[SimilarResult]> {
        return NetworkManager.shared.request(api: .similar(id: id), type: TMDBResponse.self)
            .map { result in
                switch result {
                case .success(let data): return data.results
                case .failure(let err): throw err
                }
            }
            .asObservable()
    }

    func findItem(by id: Int) -> MediaItem? {
        let allItems: [MediaItem] = topRatedItems.value + trendingItems.value + similarItems.value + popularItems.value
        return allItems.first { $0.id == id }
    }
}
