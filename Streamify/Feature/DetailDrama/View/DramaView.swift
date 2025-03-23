//
//  DramaView.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit
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
    
    override func configureHierarchy() {
        addSubviews(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        collectionView.backgroundColor = .baseBlack
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DramaHeaderCell.self, forCellWithReuseIdentifier: DramaHeaderCell.id)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "DramaPlatformCell")
        collectionView.register(DramaEpisodeCell.self, forCellWithReuseIdentifier: DramaEpisodeCell.id)
        collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CompositionalHeaderReusableView")
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
