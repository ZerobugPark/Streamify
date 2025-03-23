//
//  DramaViewController.swift
//  Streamify
//
//  Created by Sebin Kwon on 3/23/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DramaViewController: BaseViewController<DramaView, DramaViewModel> {
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<DramaSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        switch item {
        case .header(let header):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DramaHeaderCell.id, for: indexPath) as! DramaHeaderCell
            //                cell.configure(with: header)
            return cell
        case .platform(let platforms):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DramaPlatformCell", for: indexPath) as! UICollectionViewListCell
            var content = UIListContentConfiguration.valueCell()
            content.image = platforms.image
            content.imageProperties.maximumSize = CGSize(width: 30, height: 30)
            cell.contentConfiguration = content
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .darkGray
            backgroundConfig.cornerRadius = 10
            cell.backgroundConfiguration = backgroundConfig
            cell.accessories = [.disclosureIndicator()]
            
            //                    cell.configure(with: platforms)
            return cell
        case .episode(let episodes):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DramaEpisodeCell.id, for: indexPath) as! DramaEpisodeCell
            cell.backgroundColor = .darkGray
            //                    cell.configure(with: episodes[indexPath.item])
            return cell
        }
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CompositionalHeaderReusableView", for: indexPath) as! CompositionalHeaderReusableView
        header.titleLabel.text = dataSource.sectionModels[indexPath.section].model
        return header
    }
    )
    
    let sections = BehaviorRelay<[DramaSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockData()
    }
    
    override func bindViewModel() {
        sections
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func mockData() {
        
        let header = DramaHeader(
            backdropImage: nil,
            title: "슬기로운 의사생활",
            info: "시즌 2개 · 방영종료 · 드라마 · 코미디",
            overview: "누군가는 태어나고 누군가는 삶을 끝내는..."
        )
        
        let platforms: [DramaPlatform] = [
            DramaPlatform(image: .setSymbol(.eye)!),
            DramaPlatform(image: .setSymbol(.pencil)!)
        ]
        
        let episodes: [DramaEpisode] = [
            DramaEpisode(image: .setSymbol(.star)!, title: "스페셜", episodeCount: 4),
            DramaEpisode(image: .setSymbol(.star)!, title: "시즌 1", episodeCount: 12),
            DramaEpisode(image: .setSymbol(.star)!, title: "시즌 2", episodeCount: 12),
            DramaEpisode(image: .setSymbol(.star)!, title: "시즌 3", episodeCount: 12)
        ]
        
        sections.accept([
            DramaSectionModel(model: "", items: [.header(header)]),
            DramaSectionModel(model: "", items: platforms.map { .platform($0) }),
            DramaSectionModel(model: "작품 정보", items: episodes.map { .episode($0) })
        ])
    }
    
    
}

