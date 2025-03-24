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
    
    weak var coordinator: DetailCoordinator?
    
    typealias collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<DramaSectionModel>
    
    let dataSource = collectionViewDataSource(configureCell: { dataSource, collectionView, indexPath, item in
        switch item {
        case .header(let header):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DramaHeaderCell.id, for: indexPath) as! DramaHeaderCell
            cell.configure(header)
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
            backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            cell.backgroundConfiguration = backgroundConfig
            cell.accessories = [.disclosureIndicator(options: .init(tintColor: .baseWhite))]
            return cell
        case .episode(let episodes):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DramaEpisodeCell.id, for: indexPath) as! DramaEpisodeCell
            cell.configure(episodes)
            return cell
        }
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CompositionalHeaderReusableView", for: indexPath) as! CompositionalHeaderReusableView
        header.titleLabel.text = dataSource.sectionModels[indexPath.section].model
        return header
    }
    )
    
    let sectionModel = BehaviorRelay<[DramaSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockData()
    }
    
    override func bindViewModel() {
        let input = DramaViewModel.Input()
        let output = viewModel.transform(input: input)
        
        
        
        sectionModel
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        mainView.collectionView.rx.modelSelected(DramaItem.self)
            .bind(with: self) { owner, value in
                switch value {
                case .episode(let episode):
                    let vm = EpisodeViewModel()
                    let vc = EpisodeViewController(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func mockData() {
        
        let header = DramaHeader(
            backdropImage: nil,
            title: "슬기로운 의사생활",
            info: "시즌 2개 · 방영종료 · 드라마 · 코미디",
            overview: "누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는 누군가는 태어나고 누군가는 삶을 끝내는"
        )
        
        let platforms: [DramaPlatform] = [
            DramaPlatform(image: .setSymbol(.eye)),
            DramaPlatform(image: .setSymbol(.pencil))
        ]
        
        let episodes: [DramaEpisode] = [
            DramaEpisode(image: nil, title: "스페셜", episodeCount: 4),
            DramaEpisode(image: nil, title: "시즌 1", episodeCount: 12),
            DramaEpisode(image: nil, title: "시즌 2", episodeCount: 12),
            DramaEpisode(image: nil, title: "시즌 3", episodeCount: 12)
        ]
        
        sectionModel.accept([
            DramaSectionModel(model: "", items: [.header(header)]),
            DramaSectionModel(model: "", items: platforms.map { .platform($0) }),
            DramaSectionModel(model: "작품 정보", items: episodes.map { .episode($0) })
        ])
    }
    
    
}

