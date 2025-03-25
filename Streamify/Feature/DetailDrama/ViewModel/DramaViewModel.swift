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
import RealmSwift

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
    let dramaTable: DramaTable
}

final class DramaViewModel: BaseViewModel {
    
    private let dramaID: Int
    private let repository: any DramaRepository = RealmDramaRepository()
    
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
            .observe(on: MainScheduler.instance)
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
        print(data)
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
        
        let dramaTable = fetchRealm(data)
        
        var episode = [DramaItem]()
        data.seasons.forEach {
            episode.append(.episode(.init(id: data.id, seasonNumber: $0.season_number ?? 0, image: $0.poster_path ?? "", title: $0.name, episodeCount: $0.episode_count, dramaTitle: data.name, dramaTable: dramaTable)))
        }
        
        return [DramaSectionModel(model: "", items: [header]),
                DramaSectionModel(model: "", items: platform),
                DramaSectionModel(model: "작품 정보", items: episode)]
    }
    
    private func fetchRealm(_ data: DetailDrama) -> DramaTable {
        var result: DramaTable?
            if let drama = repository.findById(data.id) {
                result = drama
            } else {
                let seasons = List<Seasons>()
                
                for i in 0..<data.seasons.count {
                    let episodesTable = List<Episodes>()
                    
                    if data.seasons[i].episode_count == 0 {
                        episodesTable.append(Episodes(isWatched: false, seasonIndex: i))
                        seasons.append(Seasons(episodes:  episodesTable, wantToWatch: false))
                    }
                    
                    for _ in 0..<data.seasons[i].episode_count {
                        episodesTable.append(Episodes(isWatched: false, seasonIndex: i))
                    }
                    seasons.append(Seasons(episodes:  episodesTable, wantToWatch: false))
                }
                let drama = DramaTable(titleID: data.id, title: data.name, vote_average: nil, genre: data.genres.first?.name ?? "", imagePath: data.backdrop_path ?? "", comment: "", wantToWatch: false, seasons: seasons)
                repository.create(drama)
                result = drama
               
            }
        return result!
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
