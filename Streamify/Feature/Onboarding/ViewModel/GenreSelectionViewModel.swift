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
    let didDeselectGenre = PublishRelay<Genre>()

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
                if current.count < 3 && !current.contains(where: { $0.id == genre.id }) {
                    current.append(genre)
                    self.selectedGenres.accept(current)
                }
            })
            .disposed(by: disposeBag)

        didDeselectGenre
            .subscribe(onNext: { [weak self] genre in
                guard let self = self else { return }
                let updated = self.selectedGenres.value.filter { $0.id != genre.id }
                self.selectedGenres.accept(updated)
            })
            .disposed(by: disposeBag)
    }

    func isGenreSelected(_ genre: Genre) -> Bool {
        return selectedGenres.value.contains(where: { $0.id == genre.id })
    }

    func genreList() -> [Genre] {
        return allGenres
    }
}
