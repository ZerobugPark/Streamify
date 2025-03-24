//
//  EpisodeViewController.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EpisodeViewController: BaseViewController<EpisodeView, EpisodeViewModel> {

    typealias collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<EpisodeSectionModel>
    
    let dataSource = collectionViewDataSource(configureCell: { dataSource, collectionView, indexPath, item in
        switch item {
        case .header(let header):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeHeaderCell.id, for: indexPath) as! EpisodeHeaderCell
            cell.configure(header)
//            cell.backgroundColor = .gray
            return cell
        case .button(let button):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeButtonCell.id, for: indexPath) as! EpisodeButtonCell
//            cell.configure(header)
            cell.backgroundColor = .gray
            return cell
        case .episode(let episodes):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.id, for: indexPath) as! EpisodeCell
//            cell.configure(episodes)
            cell.backgroundColor = .gray
            return cell
        }
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CompositionalHeaderReusableView", for: indexPath) as! CompositionalHeaderReusableView
        header.titleLabel.text = dataSource.sectionModels[indexPath.section].model
        return header
    }
    )
    
    let sectionModel = BehaviorRelay<[EpisodeSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockData()
    }
    
    override func bindViewModel() {
        let input = EpisodeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        
        
        sectionModel
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
    private func mockData() {
        
        
        let header = EpisodeHeader(
            backdropImage: nil,
            title: "슬기로운 의사생활 시즌 1",
            info: "2020 · 드라마 · 코미디",
            overview: "병원에서 일어나는 다양한 이야기를 다룬 드라마입니다. 의사들의 일상과 환자들과의 관계를 따뜻하게 그려냅니다. 병원에서 일어나는 다양한 이야기를 다룬 드라마입니다. 의사들의 일상과 환자들과의 관계를 따뜻하게 그려냅니다. 병원에서 일어나는 다양한 이야기를 다룬 드라마입니다. 의사들의 일상과 환자들과의 관계를 따뜻하게 그려냅니다."
        )

        let buttons: [EpisodeButton] = [
            EpisodeButton(image: .setSymbol(.plus))
        ]

        let episodes: [EpisodeData] = [
            EpisodeData(image: nil, title: "에피소드 1", episodeCount: 1),
            EpisodeData(image: nil, title: "에피소드 2", episodeCount: 2),
            EpisodeData(image: nil, title: "에피소드 3", episodeCount: 3),
            EpisodeData(image: nil, title: "에피소드 4", episodeCount: 4),
            EpisodeData(image: nil, title: "에피소드 4", episodeCount: 4),
            EpisodeData(image: nil, title: "에피소드 4", episodeCount: 4),
            EpisodeData(image: nil, title: "에피소드 4", episodeCount: 4)
        ]

        let episodeSections = [
            EpisodeSectionModel(model: "", items: [.header(header)]),
            EpisodeSectionModel(model: "", items: buttons.map { .button($0) }),
            EpisodeSectionModel(model: "에피소드", items: episodes.map { .episode($0) })
        ]
        
        sectionModel.accept(episodeSections)
    }
    

}
