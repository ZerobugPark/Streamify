//
//  DramaView.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

enum DramaItem {
    case header(DramaHeader)
    case platform(DramaPlatform)
    case episode(DramaEpisode)
}

struct DramaSectionModel {
    var model: String
    var items: [DramaItem]
}

extension DramaSectionModel: SectionModelType {
    typealias Item = DramaItem
    
    init(original: DramaSectionModel, items: [DramaItem]) {
        self = original
        self.items = items
    }
}

struct DramaHeader {
    let backdropImage: UIImage?
    let title: String
    let info: String
    let overview: String
}

struct DramaPlatform {
    let image: UIImage?
}

struct DramaEpisode {
    let image: UIImage?
    let title: String
    let episodeCount: Int
}

final class DramaView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let disposeBag = DisposeBag()
    let sections = BehaviorRelay<[DramaSectionModel]>(value: [])
    
    override func configureHierarchy() {
        addSubviews(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
        }
        
    }
    
    override func configureView() {
        collectionView.backgroundColor = .baseBlack
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DramaHeaderCell.self, forCellWithReuseIdentifier: DramaHeaderCell.id)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "DramaPlatformCell")
        collectionView.register(DramaEpisodeCell.self, forCellWithReuseIdentifier: DramaEpisodeCell.id)
        collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CompositionalHeaderReusableView")
        bindCollectionView()
    }
    
    private func bindCollectionView() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<DramaSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .header(let header):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DramaHeaderCell.id, for: indexPath) as! DramaHeaderCell
                //                cell.configure(with: header)
                return cell
            case .platform(let platforms):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DramaPlatformCell", for: indexPath) as! UICollectionViewListCell
                var content = UIListContentConfiguration.valueCell()
                content.image = platforms.image
                content.imageProperties.maximumSize = CGSize(width: 30, height: 30)
                cell.contentConfiguration = content
                var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
                backgroundConfig.backgroundColor = .darkGray
                backgroundConfig.cornerRadius = 10
                cell.backgroundConfiguration = backgroundConfig
                cell.accessories = [.disclosureIndicator()]

                //                    cell.configure(with: platforms)
                return cell
            case .episode(let episodes):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DramaEpisodeCell.id, for: indexPath) as! DramaEpisodeCell
                cell.backgroundColor = .darkGray
                //                    cell.configure(with: episodes[indexPath.item])
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CompositionalHeaderReusableView", for: indexPath) as! CompositionalHeaderReusableView
            header.titleLabel.text = dataSource.sectionModels[indexPath.section].model
            return header
        }
        )
        
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        loadData()
    }
    
    
    private func loadData() {
        
        let header = DramaHeader(
            backdropImage: nil,
            title: "슬기로운 의사생활",
            info: "시즌 2개 · 방영종료 · 드라마 · 코미디",
            overview: "누군가는 태어나고 누군가는 삶을 끝내는..."
        )
        
        let platforms: [DramaPlatform] = [
            DramaPlatform(image: .setSymbol(.eye)!),
            DramaPlatform(image: .setSymbol(.pencil)!)
        ]
        
        let episodes: [DramaEpisode] = [
            DramaEpisode(image: .setSymbol(.star)!, title: "스페셜", episodeCount: 4),
            DramaEpisode(image: .setSymbol(.star)!, title: "시즌 1", episodeCount: 12),
            DramaEpisode(image: .setSymbol(.star)!, title: "시즌 2", episodeCount: 12),
            DramaEpisode(image: .setSymbol(.star)!, title: "시즌 3", episodeCount: 12)
        ]
        
        sections.accept([
            DramaSectionModel(model: "", items: [.header(header)]),
            DramaSectionModel(model: "", items: platforms.map { .platform($0) }),
            DramaSectionModel(model: "작품 정보", items: episodes.map { .episode($0) })
        ])
    }
    
    private static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            case 1:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
//                config.headerMode = .supplementary
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
//                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10)
                
                return section
                
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
                
            default:
                return nil
            }
        }
        return layout
    }
    
}
