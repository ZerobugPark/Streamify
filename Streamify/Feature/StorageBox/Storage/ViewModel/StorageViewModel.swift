//
//  StorageViewModel.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import Foundation

import RxCocoa
import RxSwift
import RealmSwift

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
        let setCount: BehaviorRelay<(Int, Int, Int, Int, Int)>
    }
    
    private let dataUpdatedSubject = PublishRelay<Void>()
    private let repository: any DramaRepository = RealmDramaRepository()
    
    private var wantedWatchDramas: [StorageSectionItem] = []
    private var watchedDramas: [StorageSectionItem] = []
    private var watchingDramas: [StorageSectionItem] = []
    private let emptySection: [StorageSectionItem] = []
    
    private var previousStatus: ActionButtonStatus = .all
    
    private var ratingData: [Rate] = []
    private var commentsData: [Comments] = []
    
    private var (wantedCount, watchedCount, watchingCount, commentCount, ratingCount) = (0,0,0,0,0)
    
    override init() {
        super.init()
        fetchRealmData()
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let title = ["내가 찜한 리스트", "내가 본 콘텐츠", "시청 중인 콘텐츠", ""]
        
        let sectiomModel = BehaviorRelay<[ListViewSectionModel]>(value: [.first(header: title[0], wantedWatchDramas), .second(header: title[1], watchedDramas), .third(header: title[2], watchingDramas)])
        
        let buttonToggle = PublishRelay<ActionButtonStatus>()
        let goToStarRating = PublishRelay<[Rate]>()
        let goToComment = PublishRelay<[Comments]>()
        let setCount = BehaviorRelay(value: (wantedCount, watchedCount, watchingCount, commentCount, ratingCount))
        
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
        
        
        dataUpdatedSubject.asDriver(onErrorJustReturn: ()).drive(with: self) { owner, _ in
            setCount.accept((owner.wantedCount, owner.watchedCount, owner.watchingCount, owner.commentCount, owner.ratingCount))
        }.disposed(by: disposeBag)
        
        NotificationCenterManager.progress.addObserver()
            .bind(with: self) { owner, _ in
                
                owner.wantedWatchDramas = []
                owner.watchedDramas = []
                owner.watchingDramas = []
                owner.fetchRealmData()
                
                sectiomModel.accept([.first(header: title[0], owner.wantedWatchDramas), .second(header: title[1], owner.watchedDramas), .third(header: title[2], owner.watchingDramas)])
   
            }
            .disposed(by: disposeBag)
        
        
        return Output(setSetcion: sectiomModel, buttonTogle: buttonToggle, goToStarRating: goToStarRating, goToComment: goToComment, setCount: setCount)
    }
    
    
}


extension StorageViewModel {
    
    
    private func fetchRealmData() {
        let getRealmData = Array(repository.fatchAll())
          
        let wantedWatchList = getRealmData.filter { $0.wantToWatch == true }
        let watchedList = getRealmData.filter { $0.dramaType == .watched }
        let watchingList = getRealmData.filter { $0.dramaType == .watching }
        
        

        
        categorizeDramaByType(origin: getRealmData) { [weak self] rate, comment in
            guard let self = self else { return }
            self.ratingData = rate
            self.commentsData = comment
            
            self.wantedCount = wantedWatchList.count
            self.watchedCount = watchedList.count
            self.watchingCount = watchingList.count
            self.commentCount = ratingData.count
            self.ratingCount = commentsData.count
            
            self.dataUpdatedSubject.accept(())
                        
        }
    
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
   
    private func categorizeDramaByType(origin:[DramaTable], completionHandler: @escaping ([Rate], [Comments]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var rateData: [Rate] = []
        var commentData: [Comments] = []
        
        let commnetsArray = origin.filter { !$0.comment.isEmpty }
        for item in commnetsArray {
            dispatchGroup.enter()
            fetchImageData(imagePath: item.imagePath) {
                let commnet = Comments(titleID: item.titleID, title: item.title, imagePath: $0, comment: item.comment)
                commentData.append(commnet)
                dispatchGroup.leave()
            }
        }
        
        
        let rateArray = origin.filter { $0.vote_average != nil }
        for item in rateArray {
            dispatchGroup.enter()
            fetchImageData(imagePath: item.imagePath) {
                let rate = Rate(titleID: item.titleID, title: item.title, imagePath: $0, voteAverage: item.vote_average!)
                rateData.append(rate)
                dispatchGroup.leave()
            }
        }
        
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(rateData, commentData)
        }
        
    }
    
    private func fetchImageData(imagePath: String, completionHandler: @escaping (Data?) -> ()) {
        
        
        let urlString = Config.shared.secureURL + Config.BackdropSizes.w300.rawValue + imagePath
        print(urlString)
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
