//
//  EpisodeViewModel.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum EpisodeItem {
    case header(EpisodeHeader)
    case button
    case episode(EpisodeData)
}

struct EpisodeSectionModel {
    var model: String
    var items: [EpisodeItem]
}

extension EpisodeSectionModel: SectionModelType {
    typealias Item = EpisodeItem
    
    init(original: EpisodeSectionModel, items: [EpisodeItem]) {
        self = original
        self.items = items
    }
}

struct EpisodeHeader {
    let posterImage: String
    let title: String
    let episodeCount: String
    let overview: String
}

struct EpisodeData {
    let image: String
    let title: String
    let time: String
    let date: String
    let overview: String
}


final class EpisodeViewModel: BaseViewModel {
    private let item: DramaEpisode
    init(item: DramaEpisode) {
        self.item = item
    }
    
    struct Input {
        
    }
    
    struct Output {
        let sectionModel: Driver<[EpisodeSectionModel]>
    }
    
    func transform(input: EpisodeViewModel.Input) -> Output {
        let sectionModel = BehaviorRelay<[EpisodeSectionModel]>(value: [])
        Observable.just((item.id, item.seasonNumber))
            .flatMap { (id, num) in
                NetworkManager.shared.request(api: .season(seriesID: id, seasonNumber: num), type: DetailEpisode.self)
            }
            .map { result -> DetailEpisode in
                switch result {
                case .success(let drama):
                    return drama
                case .failure:
                    return DetailEpisode(name: "", episodes: [], overview: "", poster_path: "")
                }
            }
            .bind(with: self) { owner, value in
                let result = owner.convertToSectionModel(value)
                sectionModel.accept(result)
            }
            .disposed(by: disposeBag)
        
        
        return Output(sectionModel: sectionModel.asDriver())
    }
    
    private func convertToSectionModel(_ data: DetailEpisode) -> [EpisodeSectionModel] {
        var episodeSections = [EpisodeSectionModel]()
        
        let header = EpisodeItem.header(
            EpisodeHeader(posterImage: data.poster_path ?? "", title: "\(item.dramaTitle) \(data.name)", episodeCount: "\(data.episodes.count)개 에피소드", overview: data.overview ?? "")
        )
        
        episodeSections.append(.init(model: "", items: [header]))
        episodeSections.append(.init(model: "", items: [.button]))
        
        var episode = [EpisodeItem]()
        
        data.episodes.forEach {
            let hour = ($0.runtime ?? 0) / 60
            let minutes = ($0.runtime ?? 0) % 60
            
            let date = $0.air_date.replacingOccurrences(of: "-", with: ". ")
            
            episode.append(.episode(.init(image: $0.still_path ?? "", title: "\($0.episode_number)화", time: hour != 0 ? "\(hour)시간 \(minutes)분" : "\(minutes)분", date: "\(date) 방영", overview: $0.overview ?? "")))
        
        }
        
        episodeSections.append(.init(model: "에피소드", items: episode))
        return episodeSections
    }
    
}


struct DetailEpisode: Decodable {
    let name: String
    let episodes: [DetailEpisodeItem]
    let overview: String?
    let poster_path: String?
}

struct DetailEpisodeItem: Decodable {
    let air_date: String
    let episode_number: Int
    let still_path: String?
    let runtime: Int?
    let overview: String?
}
