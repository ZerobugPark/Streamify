//
//  StarRatingStorageViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

import RxSwift
import RxCocoa

class StarRatingStorageViewController: BaseViewController<StarRatingStorageView, StarRatingStorageViewModel> {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        view.backgroundColor = .baseBlack
        
        mainView.verticalList.collectionView.register(StarRatingStorageCollectionViewCell.self, forCellWithReuseIdentifier: StarRatingStorageCollectionViewCell.id)
    }
    

    private func bind() {
        let list = Array(0...100)
        
        let listObserver = Observable.just(list)
        
        listObserver.bind(to: mainView.verticalList.collectionView.rx.items(cellIdentifier: StarRatingStorageCollectionViewCell.id, cellType: StarRatingStorageCollectionViewCell.self)) { item, element, cell in
            
            print(cell.contentView.frame.size)
            
            
        }.disposed(by: disposeBag)
        
        mainView.verticalList.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }


}

// MARK: - UICollectionViewDelegateFlowLayOut
extension StarRatingStorageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = view.frame.width
        
        print(deviceWidth)
        let spacing: CGFloat = 10
        let inset: CGFloat = 8
        
        let objectWidth = (deviceWidth - ((spacing * 2) + (inset*2))) / 3
       
        
        return CGSize(width: objectWidth, height: objectWidth * 1.5)
    }
  
}
