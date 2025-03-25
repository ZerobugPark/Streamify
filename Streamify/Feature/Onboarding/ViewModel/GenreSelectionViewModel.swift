//
//  GenreSelectionViewModel.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import Foundation
import RxCocoa
import RxSwift

final class GenreSelectionViewModel: BaseViewModel {
    
    struct Input {
        let itemSelected: Observable<IndexPath>
        let doneTap: Observable<Void>
    }

    struct Output {
        let genres: Driver<[Genre]>
        let isValid: Driver<Bool>
        let navigateNext: Signal<Void>
    }

    private let allGenres: [Genre] = Config.Genres.allCases.map {
        Genre(id: $0.rawValue, name: $0.genre)
    }
    private let selectedGenresRelay = BehaviorRelay<[Genre]>(value: [])
    private let navigateSubject = PublishRelay<Void>()

    func transform(input: Input) -> Output {
        input.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let selected = owner.allGenres[indexPath.item]
                var current = owner.selectedGenresRelay.value

                if let index = current.firstIndex(where: { $0.id == selected.id }) {
                    current.remove(at: index)
                } else {
                    guard current.count < 3 else { return }
                    var newGenre = selected
                    newGenre.order = current.count + 1
                    current.append(newGenre)
                }

                for (i, genre) in current.enumerated() {
                    current[i].order = i + 1
                }
                owner.selectedGenresRelay.accept(current)
            })
            .disposed(by: disposeBag)

        input.doneTap
            .withLatestFrom(selectedGenresRelay)
            .map { genres in
                let ids = genres.map { $0.id }
                UserDefaults.standard.set(ids, forKey: "preferredGenres")
                UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
            }
            .map { _ in () }
            .bind(to: navigateSubject)
            .disposed(by: disposeBag)

        let genres = selectedGenresRelay
            .map { [weak self] selected -> [Genre] in
                guard let self = self else { return [] }
                return self.allGenres.map { genre in
                    var updated = genre
                    if let index = selected.firstIndex(where: { $0.id == genre.id }) {
                        updated.isSelected = true
                        updated.order = index + 1
                    } else {
                        updated.isSelected = false
                        updated.order = nil
                    }
                    return updated
                }
            }
            .asDriver(onErrorJustReturn: [])

        let isValid = selectedGenresRelay
            .map { $0.count == 3 }
            .asDriver(onErrorJustReturn: false)

        return Output(
            genres: genres,
            isValid: isValid,
            navigateNext: navigateSubject.asSignal()
        )
    }
}
