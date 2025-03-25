//
//  GenreSelectionViewModel.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import Foundation
import RxCocoa
import RxSwift

class GenreSelectionViewModel {
    
    // MARK: - Input
    let didSelectGenre = PublishRelay<Genre>()
    
    // MARK: - Output
    let selectedGenres = BehaviorRelay<[Genre]>(value: [])
    var isSelectionValid: Driver<Bool> {
        return selectedGenres
            .map { $0.count == 3 }
            .asDriver(onErrorJustReturn: false)
    }
    
    private let allGenres: [Genre]
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(genres: [Genre]) {
        self.allGenres = genres
        
        didSelectGenre
            .subscribe(onNext: { [weak self] genre in
                guard let self = self else { return }
                var current = self.selectedGenres.value

                if let index = current.firstIndex(where: { $0.id == genre.id }) {
                    // 이미 선택된 경우: 선택 해제
                    current.remove(at: index)
                } else {
                    // 아직 선택되지 않은 경우: 최대 3개까지 추가
                    guard current.count < 3 else { return }

                    var newGenre = genre
                    newGenre.order = current.count + 1
                    current.append(newGenre)
                }

                // 선택 순서(order) 다시 부여
                for (idx, genre) in current.enumerated() {
                    current[idx].order = idx + 1
                }

                self.selectedGenres.accept(current)
            })
            .disposed(by: disposeBag)
    }
    
    func isGenreSelected(_ genre: Genre) -> Bool {
        return selectedGenres.value.contains(where: { $0.id == genre.id })
    }
    
    func genreList() -> [Genre] {
        return allGenres.map { genre in
            var updated = genre
            if let index = selectedGenres.value.firstIndex(where: { $0.id == genre.id }) {
                updated.isSelected = true
                updated.order = index + 1
            } else {
                updated.isSelected = false
                updated.order = nil
            }
            return updated
        }
    }
}
