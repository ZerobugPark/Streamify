//
//  EpisodeView.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit
import RxDataSources

enum EpisodeItem {
    case header(EpisodeHeader)
    case button(EpisodeButton)
    case episode(EpisodeData)
}

struct EpisodeSectionModel {
    var model: String
    var items: [EpisodeItem]
}

extension EpisodeSectionModel: SectionModelType {
    typealias Item = EpisodeItem
    
    init(original: EpisodeSectionModel, items: [EpisodeItem]) {
        self = original
        self.items = items
    }
}

struct EpisodeHeader {
    let backdropImage: UIImage?
    let title: String
    let info: String
    let overview: String
}

struct EpisodeButton {
    let image: UIImage?
}

struct EpisodeData {
    let image: UIImage?
    let title: String
    let episodeCount: Int
}

class EpisodeView: BaseView {

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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
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
