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

    var data: [Rate]
    
    lazy var rateDatas = Observable.just(data)
    
    private let filterView = FilterButton()
    
    init(vm: StarRatingStorageViewModel, data: [Rate]) {
        self.data = data
        super.init(viewModel: vm)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerStorageList()
        setupNavigation()
        view.backgroundColor = .baseBlack
    }
    

    override func bindViewModel() {
        
        
        let input = StarRatingStorageViewModel.Input(setInitialData: rateDatas)
        let output = viewModel.transform(input: input)
        
        output.setRates.bind(to: mainView.verticalList.collectionView.rx.items(cellIdentifier: StarRatingStorageCollectionViewCell.id, cellType: StarRatingStorageCollectionViewCell.self)) { item, element, cell in
            
            cell.setupUI(element)
            
        }.disposed(by: disposeBag)
        
        filterView.filterButton.rx.tap
            .map { [self] in !filterView.filterButton.isSelected } // isSelected 상태를 반전
            .bind(to: filterView.filterButton.rx.isSelected) // isSelected에 바인딩
            .disposed(by: disposeBag)
        
        
        
    }


}

// MARK: - UICollectionViewDelegateFlowLayOut
extension StarRatingStorageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = view.frame.width
        
        let spacing: CGFloat = 10
        let inset: CGFloat = 8
        
        let objectWidth = (deviceWidth - ((spacing * 2) + (inset*2))) / 3
       
        
        return CGSize(width: objectWidth, height: objectWidth * 1.5)
    }
  
}


extension StarRatingStorageViewController {
    
    // MARK: - ColletionView Register
    private func registerStorageList() {
        mainView.verticalList.collectionView.register(StarRatingStorageCollectionViewCell.self, forCellWithReuseIdentifier: StarRatingStorageCollectionViewCell.id)
        
        mainView.verticalList.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupNavigation() {
        let title = "별점"
        navigationItem.title = title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterView)
        
    }
}
