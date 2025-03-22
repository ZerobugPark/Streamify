//
//  CompositionalListView.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

final class CompositionalListView: BaseView {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: creatCompositionalLayout())
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
        collectionView.backgroundColor = .setStreamifyColor(.baseBlack)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func creatCompositionalLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
                    
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    
        
        
    }
}
