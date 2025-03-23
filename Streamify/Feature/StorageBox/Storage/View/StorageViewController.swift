//
//  StorageViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit
import SnapKit

import RxCocoa
import RxSwift
import RxDataSources
import SnapKit

enum SectionItem { //셀의 종류
    case firstSection([Int])
    case secondSection([Int])
    case thirdSection([Int])
}

enum CollectionViewSectionModel { //섹션 정의
    case first([SectionItem])
    case second([SectionItem])
    case third([SectionItem])
    
}

extension CollectionViewSectionModel: SectionModelType {
    
    typealias Item = SectionItem
    
    // dataSource의 타입에 따라서 호출 됨
    var items: [SectionItem] {
        switch self {
        case .first(let items):
            return items
        case .second(let items):
            return items
        case .third(let items):
            return items
        }
    }
    
    
    init(original: CollectionViewSectionModel, items: [Self.Item]) {
        self = original
        
    }
}

class StorageViewController: UIViewController {
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<CollectionViewSectionModel> (configureCell: { dataSource, collectionView, indexPath, item in
        
        
        switch dataSource[indexPath] { // dataSource Type == sectionItem
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
        
        
    },configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
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
        
    })
    
    
    let testView = StorageView()
    
    let disposeBag = DisposeBag()
    
    
    override func loadView() {
        view = testView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .baseBlack
        
        //레지스터 등록
        testView.storageList.collectionView.register(StorageCollectionViewCell.self, forCellWithReuseIdentifier: StorageCollectionViewCell.id)
        
        testView.storageList.collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeaderReusableView.reuseId)
        
        bind()
        
    }
    
    func bind() {
        
        
        let firstValue = Array(1...100)
        let secondValue = Array(1...100)
        let thirdValue = Array(1...100)
        
        lazy var sectiomModel: Observable<[CollectionViewSectionModel]> = Observable.just([
            .first(firstValue.map { .firstSection([$0]) }),
            .second(secondValue.map { .secondSection([$0]) }),
            .third(thirdValue.map { .thirdSection([$0]) }),
        ])
        
        
        sectiomModel.bind(to: testView.storageList.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

}
    
    

