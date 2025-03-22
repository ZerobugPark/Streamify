//
//  MainViewController.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        bindViewModel()
        viewModel.viewDidLoad.accept(())
    }

    private func setupCollectionView() {
        let layout = createMainLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TopRatedCell.self, forCellWithReuseIdentifier: TopRatedCell.id)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createMainLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            return self?.createTopRatedSectionLayout()
        }
        return layout
    }

    private func bindViewModel() {
        viewModel.topRatedItems
            .bind(to: collectionView.rx.items(cellIdentifier: TopRatedCell.id, cellType: TopRatedCell.self)) { row, item, cell in
                cell.configure(with: item.posterPath)
            }
            .disposed(by: disposeBag)

        viewModel.error
            .bind { [weak self] errorMessage in
                print("Error: \(errorMessage)")
                // 필요시 Alert 표시 가능
            }
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    func createTopRatedSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 12

        return section
    }
}

