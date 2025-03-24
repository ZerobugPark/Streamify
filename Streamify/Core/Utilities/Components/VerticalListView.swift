//
//  VerticalListView.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

import SnapKit

final class VerticalListView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    
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
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.backgroundColor = .setStreamifyColor(.baseBlack)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
    
        let interitemSpacing: CGFloat = 8
        let inset: CGFloat = 8
        
        layout.minimumInteritemSpacing = interitemSpacing
        
        layout.itemSize = CGSize(width: 10, height: 10) // 임시 값 (0을 주게 되면 경고 발생)
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        layout.scrollDirection = .vertical
        
        return layout
    }
}

