//
//  StorageViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources
import SnapKit


class StorageViewController: BaseViewController<StorageView, StorageViewModel> {
    
    
    typealias listDataSource = RxCollectionViewSectionedReloadDataSource<CollectionViewSectionModel>
    typealias colltionViewDataSource = CollectionViewSectionedDataSource<CollectionViewSectionModel>
    
    lazy var dataSource = listDataSource (
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
           
            self?.configureCell(dataSource: dataSource, collectionView: collectionView, indexPath: indexPath, item: item) ?? UICollectionViewCell()
        },
        configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
           
            self?.configureSupplementary(dataSource: dataSource, collectionView: collectionView, kind: kind, indexPath: indexPath) ?? UICollectionReusableView()
        }
    )
                                                                                                 
                                                                                                     
    override func viewDidLoad() {
        
        super.viewDidLoad()
        registerStorageList()
        
        view.backgroundColor = .setStreamifyColor(.baseBlack)

        bind()
        
    }
    
    private func bind() {
        
    
        let input = StorageViewModel.Input(setInitialData: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        
        output.test.bind(to: mainView.storageList.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

}
    
    

extension StorageViewController {
    
    // MARK: - ColletionView Register
    private func registerStorageList() {
       
        mainView.storageList.collectionView.register(StorageCollectionViewCell.self, forCellWithReuseIdentifier: StorageCollectionViewCell.id)
        
        mainView.storageList.collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeaderReusableView.reuseId)
    }
    
    // MARK: - RxDataSource Function Definition
    private func configureCell(dataSource:   colltionViewDataSource, collectionView: UICollectionView, indexPath: IndexPath, item: SectionItem) -> UICollectionViewCell {
       
        switch dataSource[indexPath] {
        case .firstSection, .secondSection, .thirdSection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorageCollectionViewCell.id, for: indexPath) as? StorageCollectionViewCell else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case .firstSection:
                cell.label.text = "1"
            case .secondSection:
                cell.label.text = "2"
            case .thirdSection:
                cell.label.text = "3"
            }
            return cell
        }
        
    }
    
    private func configureSupplementary(dataSource: colltionViewDataSource, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompositionalHeaderReusableView.reuseId, for: indexPath) as? CompositionalHeaderReusableView else {
            return UICollectionReusableView()
        }
        switch indexPath.section {
        case 0:
            headerView.titleLabel.text = "내가 찜한 리스트"
        case 1:
            headerView.titleLabel.text = "내가 본 콘텐츠"
        case 2:
            headerView.titleLabel.text = "시청 중인 콘텐츠"
        default:
            break
        }
        return headerView
        
    }
    
}

