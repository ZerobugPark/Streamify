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

enum ActionButtonStatus {
    case wantToWatchButton
    case watchedButton
    case watchingButton
    case commentButton
    case ratingButton
    case all
}


final class StorageViewController: BaseViewController<StorageView, StorageViewModel> {
    
    weak var coordinator: MainCoordinator?
    
    typealias listDataSource = RxCollectionViewSectionedReloadDataSource<ListViewSectionModel>
    typealias colltionViewDataSource = CollectionViewSectionedDataSource<ListViewSectionModel>
    
    private lazy var dataSource = listDataSource (
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            
            self?.configureCell(dataSource: dataSource, collectionView: collectionView, indexPath: indexPath, item: item) ?? UICollectionViewCell()
        },
        configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in

            self?.configureSupplementary(dataSource: dataSource, collectionView: collectionView, kind: kind, indexPath: indexPath) ?? UICollectionReusableView()
        }
    )
    
    private let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: nil, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerStorageList()
        setupNavigation()
        
    }
    
    override func bindViewModel() {
        
        
        let actionButtonTapped = Observable.merge(
            mainView.wantToWatchButton.rx.tap.map { ActionButtonStatus.wantToWatchButton },
            mainView.watchedButton.rx.tap.map { ActionButtonStatus.watchedButton },
            mainView.watchingButton.rx.tap.map { ActionButtonStatus.watchingButton },
            mainView.commentButton.rx.tap.map { ActionButtonStatus.commentButton },
            mainView.ratingButton.rx.tap.map { ActionButtonStatus.ratingButton }
        )
        
        
        let input = StorageViewModel.Input(setInitialData: Observable.just(()),
                                           actionButtonTapped: actionButtonTapped)
        
        
        let output = viewModel.transform(input: input)
        
        
        mainView.storageList.collectionView.rx.modelSelected(StorageSectionItem.self).bind(with: self) { owner, element in
            
            switch element {
            case .firstSection(let data), .secondSection(let data), .thirdSection(let data):
                owner.coordinator?.showDetail(for: data.titleID)
            }
            
            
            
        }.disposed(by: disposeBag)
        
        rightBarButton.rx.tap.bind(with: self) { owner, _ in
            
            owner.coordinator?.showModifyScreen()
            
        }.disposed(by: disposeBag)
        
        output.setSetcion.bind(to: mainView.storageList.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        
        output.goToStarRating.asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, data in
                
                owner.coordinator?.showStarRatingScreen(data: data)
            }.disposed(by: disposeBag)
        
        output.goToComment.asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, data in

                
                owner.coordinator?.showCommentScreen(data: data)
            }.disposed(by: disposeBag)
        
        output.setCount.bind(with: self) { owenr, value in
            owenr.mainView.wantToWatchButton.updateTitle(String(value.0))
            owenr.mainView.watchedButton.updateTitle(String(value.1))
            owenr.mainView.watchingButton.updateTitle(String(value.2))
            owenr.mainView.commentButton.updateTitle(String(value.3))
            owenr.mainView.ratingButton.updateTitle(String(value.4))
            
            
        }.disposed(by: disposeBag)
        
        output.buttonTogle.asDriver(onErrorJustReturn: .all).drive(with: self) { owner, status in
            
            [owner.mainView.wantToWatchButton, owner.mainView.watchedButton, owner.mainView.watchingButton].forEach {
                $0.isSelected = false
            }

            switch status {
            case .wantToWatchButton:
                owner.mainView.wantToWatchButton.isSelected.toggle()
            case .watchedButton:
                owner.mainView.watchedButton.isSelected.toggle()
            case .watchingButton:
                owner.mainView.watchingButton.isSelected.toggle()
            case .commentButton:
                fallthrough
            case .ratingButton:
                fallthrough
            case .all:
                return
            }
            
        }.disposed(by: disposeBag)
    }
    
    
    
}



extension StorageViewController {
    
    // MARK: - ColletionView Register
    private func registerStorageList() {
        
        mainView.storageList.collectionView.register(StorageCollectionViewCell.self, forCellWithReuseIdentifier: StorageCollectionViewCell.id)
        
        mainView.storageList.collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeaderReusableView.reuseId)
        
        mainView.storageList.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "basicHeader")
    }
    
    // MARK: - Navigation Setup
    private func setupNavigation() {
        let title = "보관함"
        navigationItem.title = title
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - RxDataSource Function Definition
    private func configureCell(dataSource:   colltionViewDataSource, collectionView: UICollectionView, indexPath: IndexPath, item: StorageSectionItem) -> UICollectionViewCell {
        
        switch dataSource[indexPath] {
        case .firstSection, .secondSection, .thirdSection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorageCollectionViewCell.id, for: indexPath) as? StorageCollectionViewCell else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case .firstSection(let data):
                cell.setupUI(data)
            case .secondSection(let data):
                cell.setupUI(data)
            case .thirdSection(let data):
                cell.setupUI(data)
            }
            return cell
            
    
        }
        
    }
    
    private func configureSupplementary(dataSource: colltionViewDataSource, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let sectionModel = dataSource.sectionModels[indexPath.section]

          // 해당 섹션이 비어있으면 헤더 안 보이게 처리        
        if sectionModel.items.isEmpty {
            // 섹션이 비어있을 경우, 기본 헤더를 반환
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "basicHeader",
                for: indexPath)
            return headerView
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompositionalHeaderReusableView.reuseId, for: indexPath) as? CompositionalHeaderReusableView else {
            return UICollectionReusableView()
        }
        
        
        switch indexPath.section {
        case 0:
            headerView.titleLabel.text = dataSource.sectionModels[indexPath.section].header
        case 1:
            headerView.titleLabel.text = dataSource.sectionModels[indexPath.section].header
        case 2:
            headerView.titleLabel.text = dataSource.sectionModels[indexPath.section].header
        default:
            break
        }
        return headerView
        
    }
    
}

