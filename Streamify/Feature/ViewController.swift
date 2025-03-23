//
//  ViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    let collectionViewTestBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        NetworkManager.shared.request(api: .trending, type: TMDBResponse.self)
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let data):
                    dump("받은 데이터: \(data)")
                case .failure(let error):
                    dump("에러 발생: \(error)")
                }
            })
            .disposed(by: disposeBag)
        configure()
    }
    
    func configure() {
        
        view.addSubview(collectionViewTestBtn)
        collectionViewTestBtn.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.center.equalToSuperview()
        }
        
        collectionViewTestBtn.setTitle("CollectionView Test", for: .normal)
        
        collectionViewTestBtn.addAction(UIAction { [weak self] _ in
            
            let viewModel = StorageViewModel()//StarRatingStorageViewModel()
            let vc = StorageViewController(viewModel: viewModel)//StarRatingStorageViewController(viewModel: viewModel)
            
            self?.present(vc,animated: true)
            
        }, for: .touchUpInside)
    }


}

