//
//  EpisodeButtonCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

final class EpisodeButtonCell: BaseCollectionViewCell {
    
    private let dramaRepository: any DramaRepository = RealmDramaRepository()
    private let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()
    private var season: Seasons?
    private var episodes: List<Episodes>?
    private var drama: DramaTable?
    private var seasonIndex: Int?
    private var progressDisposable: Disposable?
    
    private let wantButton = ActionButton(title: "찜", image: .plus)
    private let watchedButton = ActionButton(title: "봤어요", image: .checkmark)
    private let watchingButton = ActionButton(title: "보는중", image: .eye)
    private let commentButton = ActionButton(title: "코멘트", image: .pencil)
    private let starButton = ActionButton(title: "별점", image: .starCircle)
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        progressDisposable?.dispose()
        progressDisposable = nil
    }
    
    override func configureHierarchy() {
        addSubviews(stackView)
        stackView.addArrangedSubviews(
            wantButton,
            watchedButton,
            watchingButton,
            commentButton,
            starButton
        )
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ episodes: List<Episodes>, _ index: Int, _ season: Seasons, _ drama: DramaTable) {
        self.episodes = episodes
        self.season = season
        self.seasonIndex = index
        self.drama = drama
        bind()
    }
    
    private func bind() {
        guard let drama else { return }
        guard let episodes else { return }
        guard let season else { return }
        progressDisposable?.dispose()
        
        let isWatchedCount = episodes.filter { $0.isWatched }.count
        
        watchedButton.isSelected = isWatchedCount == episodes.count
        watchingButton.isSelected = isWatchedCount > 0 && isWatchedCount < episodes.count
        wantButton.isSelected = season.wantToWatch
        
        progressDisposable = NotificationCenterManager.progress.addObserver()
            .bind(with: self) { owner, value in
                guard let seasonIndex = owner.seasonIndex,
                      let notiIndex = value as? Int,
                      seasonIndex == notiIndex else { return }
                
                let isWatchedCount = episodes.filter { $0.isWatched }.count
                owner.watchedButton.isSelected = isWatchedCount == episodes.count
                owner.watchingButton.isSelected = isWatchedCount > 0 && isWatchedCount < episodes.count
            }
        
        progressDisposable?.disposed(by: disposeBag)
        
        wantButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.wantButton.isSelected.toggle()
                owner.dramaRepository.toggleSeasonWant(season: season)
                for value in drama.seasons {
                    if value.wantToWatch == true {
                        owner.dramaRepository.changeDramaWant(drama: drama, value: true)
                        return
                    }
                }
                owner.dramaRepository.changeDramaWant(drama: drama, value: false)
            }
            .disposed(by: disposeBag)
    }
}
