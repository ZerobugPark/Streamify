//
//  DramaViewModel.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum DramaItem {
    case header(DramaHeader)
    case platform(DramaPlatform)
    case episode(DramaEpisode)
}

struct DramaSectionModel {
    var model: String
    var items: [DramaItem]
}

extension DramaSectionModel: SectionModelType {
    typealias Item = DramaItem
    
    init(original: DramaSectionModel, items: [DramaItem]) {
        self = original
        self.items = items
    }
}

struct DramaHeader {
    let backdropImage: String
    let title: String
    let info: String
    let overview: String
}

struct DramaPlatform {
    let image: String
}

struct DramaEpisode {
    let id: Int
    let seasonNumber: Int
    let image: String
    let title: String
    let episodeCount: Int
    let dramaTitle: String
}

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
        let sectionModel = PublishRelay<[DramaSectionModel]>()
        
        Observable.just(dramaID)
            .flatMap { value in
                NetworkManager.shared.request(api: .series(id: value), type: DetailDrama.self)
            }
            .map { result -> DetailDrama in
                switch result {
                case .success(let drama):
                    return drama
                case .failure:
                    return DetailDrama(id: 0, name: "", backdrop_path: "", genres: [], overview: "", seasons: [], networks: [], status: "")
                }
            }
            .bind(with: self) { owner, value in
                let result = owner.convertToSectionModel(value)
                sectionModel.accept(result)
            }
            .disposed(by: disposeBag)
        
        return Output(sectionModel: sectionModel.asDriver(onErrorJustReturn: []))
    }
    
    private func convertToSectionModel(_ data: DetailDrama) -> [DramaSectionModel] {
        
        var infoText = "시즌 \(data.seasons.count)개 · \(DramaStatus(rawValue: data.status)?.krStatus ?? "")"
        
        data.genres.forEach {
            infoText += " · \( $0.name)"
        }
        
        let header = DramaItem.header(
            DramaHeader(backdropImage: data.backdrop_path ?? "",
                        title: data.name,
                        info: infoText,
                        overview: data.overview))
        
        var platform = [DramaItem]()
        data.networks.forEach {
            platform.append(.platform(.init(image: $0.logo_path ?? "star")))
        }
        
        var episode = [DramaItem]()
        data.seasons.forEach {
            episode.append(.episode(.init(id: data.id, seasonNumber: $0.season_number, image: $0.poster_path ?? "", title: $0.name, episodeCount: $0.episode_count, dramaTitle: data.name)))
        }
        
        return [DramaSectionModel(model: "", items: [header]),
                DramaSectionModel(model: "", items: platform),
                DramaSectionModel(model: "작품 정보", items: episode)]
    }
    
    enum DramaStatus: String {
        case returningSeries = "Returning Series"
        case ended = "Ended"
        var krStatus: String {
            switch self {
            case .returningSeries: "방영중"
            case .ended: "방영 종료"
            }
        }
    }
    
}
