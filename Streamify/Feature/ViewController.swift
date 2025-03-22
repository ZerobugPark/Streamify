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
    }


}

