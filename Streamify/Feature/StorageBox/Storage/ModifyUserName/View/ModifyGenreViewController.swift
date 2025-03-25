//
//  ModifyGenreViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/25/25.
//

import UIKit

import RxCocoa
import RxSwift


final class ModifyGenreViewController: BaseViewController<GenreSelectionView, GenreSelectionViewModel> {
    
    weak var coordinator: MainCoordinator?
    var userName: String?
    private var genres: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.dataSource = self
    }
    
    override func bindViewModel() {
        let input = GenreSelectionViewModel.Input(
            itemSelected: mainView.collectionView.rx.itemSelected.asObservable(),
            doneTap: mainView.doneButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.genres
            .drive(with: self) { owner, newGenres in
                owner.genres = newGenres
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.isValid
            .drive(mainView.doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isValid
            .map { $0 ? UIColor.systemBlue : UIColor.lightGray }
            .drive(mainView.doneButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.navigateNext
            .emit(with: self) { owner, _ in
                NotificationCenterManager.isChanged.post()
                owner.coordinator?.popViewController()
            }
            .disposed(by: disposeBag)
    }
}




extension ModifyGenreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCell.id,
            for: indexPath
        ) as? GenreCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: genres[indexPath.item])
        return cell
    }
}
