import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return MainViewController.createTopRatedSectionLayout()
            default:
                return MainViewController.createHorizontalSectionLayout()
            }
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<MainSectionModel>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            
            let section = dataSource.sectionModels[indexPath.section]
            
            switch section {
            case .topRated:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedCell.id, for: indexPath) as? TopRatedCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: item.posterPath)
                return cell
                
            case .horizontal:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalMediaCell.id, for: indexPath) as? HorizontalMediaCell else {
                    return UICollectionViewCell()
                }
                let genre = Config.Genres(rawValue: item.genreIDS.first ?? 0)?.genre
                cell.configure(title: item.name, genre: genre, imagePath: item.backdropPath)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompositionalHeaderReusableView.reuseId, for: indexPath) as? CompositionalHeaderReusableView else {
                return UICollectionReusableView()
            }
            
            let section = dataSource.sectionModels[indexPath.section]
            switch section {
            case .horizontal(let title, _):
                header.titleLabel.text = title
            default:
                header.titleLabel.text = nil
            }
            
            return header
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigationBar()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad.accept(())
    }
    
    private func setupNavigationBar() {
        title = "Streamify"
        
        let storageButton = UIBarButtonItem(
            image: UIImage(systemName: "folder"),
            style: .plain,
            target: self,
            action: #selector(didTapStorage)
        )
        
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapSearch)
        )
        
        navigationItem.leftBarButtonItem = storageButton
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func didTapStorage() {
        coordinator?.showStorageScreen()
    }
    
    @objc private func didTapSearch() {
        coordinator?.showSearchScreen()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        collectionView.register(TopRatedCell.self, forCellWithReuseIdentifier: TopRatedCell.id)
        collectionView.register(HorizontalMediaCell.self, forCellWithReuseIdentifier: HorizontalMediaCell.id)
        collectionView.register(
            CompositionalHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CompositionalHeaderReusableView.reuseId
        )
    }
    
    private func bindViewModel() {
        viewModel.error
            .bind { error in
                print("Error: \(error)")
            }
            .disposed(by: disposeBag)

        viewModel.sectionModels
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                let section = owner.dataSource.sectionModels[indexPath.section]
                let item = section.items[indexPath.item]
                owner.coordinator?.showDetail(for: item)
            }
            .disposed(by: disposeBag)
    }
    
    // TODO: 맨 처음 셀, 마지막 셀 연결 필요
    static func createTopRatedSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                               heightDimension: .absolute(420))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 12
        
        return section
    }
    
    static private func createHorizontalSectionLayout() -> NSCollectionLayoutSection {
        // 1. 셀 크기: 너비의 40%, 높이는 그룹 전체
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

        // 2. 그룹: 셀 하나만 포함, 그룹 자체가 40% 너비
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // 3. 섹션: 연속 스크롤 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16)

        // 4. 헤더 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [headerItem]
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        return section
    }
}
