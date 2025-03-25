//
//  EpisodeCellViewModel.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class EpisodeCellViewModel: BaseViewModel {
    private let dramaRepository: any DramaRepository = RealmDramaRepository()
    private let episode: Episodes
    
    init(episode: Episodes) {
        self.episode = episode
    }
    
    struct Input {
        let checkButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let checkButtonTap: Driver<Bool>
    }
    
    func transform(input: EpisodeCellViewModel.Input) -> Output {
        let checkButtonTap = PublishRelay<Bool>()
        let isWatched = BehaviorRelay(value: episode.isWatched)
        
        input.checkButtonTap
            .withLatestFrom(isWatched)
            .map { !$0 }
            .bind(with: self) { owner, value in
                owner.dramaRepository.toggleEpisodeWatched(episode: owner.episode)
                print("viewModel value :", owner.episode.isWatched)
                print("viewModel value :", value)
                checkButtonTap.accept(value)
                NotificationCenterManager.progress.post(object: owner.episode.seasonIndex)
            }
            .disposed(by: disposeBag)
        
        
        return Output(checkButtonTap: checkButtonTap.asDriver(onErrorJustReturn: false))
    }
    
}
