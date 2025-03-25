//
//  GenreSelectionViewController.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class GenreSelectionViewController: UIViewController {

    weak var coordinator: OnboardingCoordinator?
    let mainView = GenreSelectionView()
    var userName: String?

    private let disposeBag = DisposeBag()
    private var viewModel: GenreSelectionViewModel!

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        bindViewModel()
    }

    private func configureViewModel() {
        let genres = Config.Genres.allCases.map { Genre(id: $0.rawValue, name: $0.genre) }
        viewModel = GenreSelectionViewModel(genres: genres)
    }

    private func bindViewModel() {
        mainView.collectionView.dataSource = self

        mainView.collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                let genre = owner.viewModel.genreList()[indexPath.item]
                owner.viewModel.didSelectGenre.accept(genre)
            }
            .disposed(by: disposeBag)

        viewModel.selectedGenres
            .bind(onNext: { [weak self] _ in
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.isSelectionValid
            .drive(mainView.doneButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isSelectionValid
            .map { $0 ? UIColor.systemBlue : UIColor.lightGray }
            .drive(mainView.doneButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        mainView.doneButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let selected = self.viewModel.selectedGenres.value
                let selectedIDs = selected.map { $0.id }
                UserDefaults.standard.set(self.userName, forKey: "userName")
                UserDefaults.standard.set(selectedIDs, forKey: "preferredGenres")
                UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
                self.coordinator?.finishOnboarding()
            }
            .disposed(by: disposeBag)
    }
}

extension GenreSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.genreList().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.id, for: indexPath) as? GenreCell else {
            return UICollectionViewCell()
        }

        let genre = viewModel.genreList()[indexPath.item]
        var configured = genre
        configured.isSelected = viewModel.isGenreSelected(genre)
        cell.configure(with: configured)
        return cell
    }
}
