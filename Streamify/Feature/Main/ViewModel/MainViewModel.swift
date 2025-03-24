//
//  MainViewModel.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

enum MainSectionModel {
    case topRated([MediaItem])
    case horizontal(title: String, items: [MediaItem])
}

extension MainSectionModel: SectionModelType {
    typealias Item = MediaItem

    var items: [MediaItem] {
        switch self {
        case .topRated(let items): return items
        case .horizontal(_, let items): return items
        }
    }

    init(original: MainSectionModel, items: [MediaItem]) {
        switch original {
        case .topRated:
            self = .topRated(items)
        case .horizontal(let title, _):
            self = .horizontal(title: title, items: items)
        }
    }
}

final class MainViewModel {

    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()

    // MARK: - Output
    let topRatedItems = BehaviorRelay<[TopRatedResult]>(value: [])
    let trendingItems = BehaviorRelay<[TrendingResult]>(value: [])
    let similarItems = BehaviorRelay<[SimilarResult]>(value: [])
    let popularItems = BehaviorRelay<[PopularResult]>(value: [])
    let sectionModels = BehaviorRelay<[MainSectionModel]>(value: [])
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

                // topRated에서 유사 콘텐츠 기준 ID 추출
                // TODO: 실제 사용자 관심 항목으로 변경 필요
                let topId = topRated.first?.id ?? 0

                self.fetchSimilar(from: topId)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { similar in
                        self.similarItems.accept(similar)

                        let sections: [MainSectionModel] = [
                            .topRated(topRated),
                            .horizontal(title: "실시간 인기 드라마", items: trending),
                            // TODO: 실제 항목의 이름으로 변경 필요
                            .horizontal(title: "내 관심사와 비슷한 콘텐츠", items: similar),
                            .horizontal(title: "지금 뜨는 콘텐츠", items: popular)
                        ]
                        self.sectionModels.accept(sections)

                    })
                    .disposed(by: self.disposeBag)

            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.error.accept("네트워크 오류: \(error.localizedDescription)")
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
