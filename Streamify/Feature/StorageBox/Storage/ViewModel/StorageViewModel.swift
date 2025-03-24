//
//  StorageViewModel.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import Foundation

import RxCocoa
import RxSwift

final class StorageViewModel: BaseViewModel {
    
    struct Input {
        let setInitialData: Observable<()>
        let actionButtonTapped: Observable<ActionButtonStatus>
    }
    
    struct Output {
        let setSetcion: BehaviorRelay<[ListViewSectionModel]>
        let buttonTogle: PublishRelay<ActionButtonStatus>
        let goToStarRating: PublishRelay<[Rate]>
        let goToComment: PublishRelay<[Comments]>
    }
    
    
    private var wantedWatchDramas: [StorageSectionItem] = []
    private var watchedDramas: [StorageSectionItem] = []
    private var watchingDramas: [StorageSectionItem] = []
    private let emptySection: [StorageSectionItem] = []
    
    private var previousStatus: ActionButtonStatus = .all
    
    private var ratingData: [Rate] = []
    private var commentsData: [Comments] = []
    
    override init() {
        super.init()
        
        let data = generateMockData()
        
        categorizeDramaByType(origin: data) { [weak self] rate, comment in
            guard let self = self else { return }
            self.ratingData = rate
            self.commentsData = comment
        }
        
        let wantedWatchList = data.filter { $0.dramaType == .none }
        let watchedList = data.filter { $0.dramaType == .watched }
        let watchingList = data.filter { $0.dramaType == .watching }
        
        
        for item in wantedWatchList {
            wantedWatchDramas.append(.firstSection(item))
        }
        
        for item in watchedList {
            watchedDramas.append(.secondSection(item))
        }
        
        for item in watchingList {
            watchingDramas.append(.thirdSection(item))
        }
        
        
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let title = ["내가 찜한 리스트", "내가 본 콘텐츠", "시청 중인 콘텐츠", ""]
        
        let sectiomModel = BehaviorRelay<[ListViewSectionModel]>(value: [.first(header: title[0], wantedWatchDramas), .second(header: title[1], watchedDramas), .third(header: title[2], watchingDramas)])
        
        let buttonToggle = PublishRelay<ActionButtonStatus>()
        let goToStarRating = PublishRelay<[Rate]>()
        let goToComment = PublishRelay<[Comments]>()
        
        input.actionButtonTapped.bind(with: self) { owner, tag in
            
            if owner.previousStatus == tag {
                
                sectiomModel.accept([.first(header: title[0], owner.wantedWatchDramas), .second(header: title[1], owner.watchedDramas), .third(header: title[2], owner.watchingDramas)])
                buttonToggle.accept(.all)
                
                owner.previousStatus = .all
                return
            }
            
            switch tag {
            case .wantToWatchButton:
                sectiomModel.accept([.first(header: title[0], owner.wantedWatchDramas), .second(header: title[3], owner.emptySection), .third(header: title[3], owner.emptySection)])
                buttonToggle.accept(.wantToWatchButton)
            case .watchedButton:
                sectiomModel.accept([.first(header: title[1], owner.watchedDramas), .second(header: title[3], owner.emptySection), .third(header: title[3], owner.emptySection)])
                buttonToggle.accept(.watchedButton)
            case .watchingButton:
                sectiomModel.accept([.first(header: title[2], owner.watchingDramas), .second(header: title[3], owner.emptySection), .third(header: title[3], owner.emptySection)])
                buttonToggle.accept(.watchingButton)
            case .commentButton:
                goToComment.accept(owner.commentsData)
                return
            case .ratingButton:
                goToStarRating.accept(owner.ratingData)
                return
            case .all:
                break
            }
            
            owner.previousStatus = tag
            
        }.disposed(by: disposeBag)
        
        return Output(setSetcion: sectiomModel, buttonTogle: buttonToggle, goToStarRating: goToStarRating, goToComment: goToComment)
    }
    
    
}


extension StorageViewModel {
    
    private func categorizeDramaByType(origin:[Drama], completionHandler: @escaping ([Rate], [Comments]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var rateData: [Rate] = []
        var commentData: [Comments] = []
        
        let commnetsArray = origin.filter { !$0.comment.isEmpty }
        for item in commnetsArray {
            dispatchGroup.enter()
            fetchImageData(imagePath: item.imagePath) {
                let commnet = Comments(id: item.id, titleID: item.titleID, title: item.title, imagePath: $0, comment: item.imagePath)
                commentData.append(commnet)
                dispatchGroup.leave()
            }
        }
        
        
        let rateArray = origin.filter { $0.voteAverage != 0.0 }
        for item in rateArray {
            dispatchGroup.enter()
            fetchImageData(imagePath: item.imagePath) {
                let rate = Rate(id: item.id, titleID: item.titleID, title: item.title, imagePath: $0, voteAverage: item.voteAverage )
                rateData.append(rate)
                dispatchGroup.leave()
            }
        }
        
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(rateData, commentData)
        }
       
    }
    
    private func fetchImageData(imagePath: String, completionHandler: @escaping (Data?) -> ()) {
        
        
        let urlString = imagePath
        guard let url = URL(string: urlString) else { completionHandler(nil); return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completionHandler(nil)
                return
            }
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
            
            
        }.resume()
   
    }
}
    



struct Drama {
    var id: String
    var titleID: Int
    var title: String
    var voteAverage: Double
    var genre: String
    var imagePath: String
    var comment: String
    var episodes: [Episode]
    var watchingProgress: Float {
        let watchedCount = episodes.filter { $0.isWatched }.count
        return episodes.isEmpty ? 0.0 : Float(watchedCount) / Float(episodes.count)
    }
    var dramaType: DramaType {
        switch watchingProgress {
        case 0.0: return .none
        case 1.0: return .watched
        default: return .watching
        }
    }
}

struct Episode {
    var isWatched: Bool
    var title: String
}

func generateMockData() -> [Drama] {
    // "봤어요" 드라마들 (watched)
    let watchedDramas: [Drama] = (1...10).map { index in
        let episode1 = Episode(isWatched: true, title: "Episode 1")
        let episode2 = Episode(isWatched: true, title: "Episode 2")
        let episode3 = Episode(isWatched: true, title: "Episode 3")
        
        return Drama(
            id: "\(index)",
            titleID: 100 + index,
            title: "Watched Drama \(index)",
            voteAverage: Double.random(in: 6.0...9.0),
            genre: ["Action", "Drama", "Comedy", "Sci-Fi"].randomElement()!,
            imagePath: Config.shared.secureURL + Config.BackdropSizes.w300.rawValue + "/8MtMFngDWvIdRo34rz3ao0BGBAe.jpg",
            comment: "This is a comment for Watched Drama \(index).",
            episodes: [episode1, episode2, episode3]
        )
    }
    
    // "시청 중" 드라마들 (watching)
    let watchingDramas: [Drama] = (11...20).map { index in
        let episode1 = Episode(isWatched: true, title: "Episode 1")
        let episode2 = Episode(isWatched: false, title: "Episode 2")
        let episode3 = Episode(isWatched: false, title: "Episode 3")
        
        return Drama(
            id: "\(index)",
            titleID: 100 + index,
            title: "Watching Drama \(index)",
            voteAverage: Double.random(in: 6.0...9.0),
            genre: ["Action", "Drama", "Comedy", "Sci-Fi"].randomElement()!,
            imagePath: Config.shared.secureURL + Config.BackdropSizes.w300.rawValue + "/8MtMFngDWvIdRo34rz3ao0BGBAe.jpg",
            comment: "This is a comment for Watching Drama \(index).",
            episodes: [episode1, episode2, episode3]
        )
    }
    
    // "시청 예정" 드라마들 (not yet watched, for none category)
    let noneDramas: [Drama] = (21...30).map { index in
        let episode1 = Episode(isWatched: false, title: "Episode 1")
        let episode2 = Episode(isWatched: false, title: "Episode 2")
        let episode3 = Episode(isWatched: false, title: "Episode 3")
        
        return Drama(
            id: "\(index)",
            titleID: 100 + index,
            title: "Not Watched Drama \(index)",
            voteAverage: Double.random(in: 6.0...9.0),
            genre: ["Action", "Drama", "Comedy", "Sci-Fi"].randomElement()!,
            imagePath: Config.shared.secureURL + Config.BackdropSizes.w300.rawValue + "/8MtMFngDWvIdRo34rz3ao0BGBAe.jpg",
            comment: "This is a comment for Not Watched Drama \(index).",
            episodes: [episode1, episode2, episode3]
        )
    }
    
    // 전체 드라마 목록 반환 (봤어요, 시청 중, 시청 예정)
    return watchedDramas + watchingDramas + noneDramas
}
