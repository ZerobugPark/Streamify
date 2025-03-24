//
//  EpisodeModalViewController.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/24/25.
//

import UIKit

enum ModalType {
    case comment
    case star
}

class EpisodeModalViewController: UIViewController {
    
    let type: ModalType
    
    init(type: ModalType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
    let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        //view.backgroundColor = .baseBlack
        navigationItem.title = type == .comment ? "코멘트" : "별점"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
