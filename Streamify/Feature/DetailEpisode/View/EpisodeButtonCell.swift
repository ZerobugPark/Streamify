//
//  EpisodeButtonCell.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EpisodeButtonCell: BaseCollectionViewCell {
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()
    
    let wantButton = ActionButton(title: "찜", image: .plus)
    let watchedButton = ActionButton(title: "봤어요", image: .checkmark)
    let watchingButton = ActionButton(title: "보는중", image: .eye)
    let commentButton = ActionButton(title: "코멘트", image: .pencil)
    let starButton = ActionButton(title: "별점", image: .starCircle)
    
    let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        addSubviews(stackView)
        stackView.addArrangedSubviews(
            wantButton,
            watchedButton,
            watchingButton,
            commentButton,
            starButton
        )
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
