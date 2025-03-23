//
//  MainViewController.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {

    private let topRatedCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return MainViewController.createTopRatedSectionLayout()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TopRatedCell.self, forCellWithReuseIdentifier: TopRatedCell.id)
        return collectionView
    }()

    private let horizontalListView = CompositionalListView()

    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<CollectionViewSectionModel> (configureCell: { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalMediaCell.id, for: indexPath) as? HorizontalMediaCell else {
            return UICollectionViewCell()
        }

        let mediaItem: MediaItem
        switch dataSource[indexPath] {
        case .firstSection(let ids), .secondSection(let ids), .thirdSection(let ids):
            guard let id = ids.first,
                  let matched = self.viewModel.findItem(by: id) else { return cell }
            mediaItem = matched
        }

        let genreName = Config.Genres(rawValue: mediaItem.genreIDS.first ?? 0)?.genre
        cell.configure(title: mediaItem.name,
                       genre: genreName,
                       imagePath: mediaItem.posterPath)
        return cell
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompositionalHeaderReusableView.reuseId, for: indexPath) as? CompositionalHeaderReusableView else {
            return UICollectionReusableView()
        }

        switch indexPath.section {
        case 0:
            headerView.titleLabel.text = "실시간 인기 드라마"
        case 1:
            headerView.titleLabel.text = "비슷한 콘텐츠"
        case 2:
            headerView.titleLabel.text = "지금 뜨는 콘텐츠"
        default:
            break
        }

        return headerView
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad.accept(())
    }

    private func setupUI() {
        view.addSubview(topRatedCollectionView)
        view.addSubview(horizontalListView)

        topRatedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalListView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topRatedCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topRatedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topRatedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topRatedCollectionView.heightAnchor.constraint(equalToConstant: 300),

            horizontalListView.topAnchor.constraint(equalTo: topRatedCollectionView.bottomAnchor, constant: 12),
            horizontalListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        horizontalListView.collectionView.register(HorizontalMediaCell.self, forCellWithReuseIdentifier: HorizontalMediaCell.id)
        horizontalListView.collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeaderReusableView.reuseId)
    }

    private func bindViewModel() {
        viewModel.topRatedItems
            .bind(to: topRatedCollectionView.rx.items(cellIdentifier: TopRatedCell.id, cellType: TopRatedCell.self)) { row, item, cell in
                cell.configure(with: item.posterPath)
            }
            .disposed(by: disposeBag)

        viewModel.error
            .bind { error in
                print("Error: \(error)")
            }
            .disposed(by: disposeBag)

        viewModel.sectionModels
            .bind(to: horizontalListView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    static func createTopRatedSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 12

        return section
    }
}

