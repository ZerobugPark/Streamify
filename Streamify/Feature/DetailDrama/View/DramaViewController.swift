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
    
    lazy var dataSource = collectionViewDataSource(configureCell: { [weak self] dataSource, collectionView, indexPath, item in
        switch item {
        case .header(let header):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DramaHeaderCell.id, for: indexPath) as! DramaHeaderCell
            cell.configure(header)
            return cell
            
        case .platform(let platforms):
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DramaPlatformCell", for: indexPath) as! UICollectionViewListCell
            cell = (self?.configureListCell(cell, platforms))!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        let input = DramaViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.sectionModel
            .drive(mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        mainView.collectionView.rx.modelSelected(DramaItem.self)
            .bind(with: self) { owner, value in
                switch value {
                case .episode(let episode):
                    owner.coordinator?.showEpisodeList(episode)
//                    let vm = EpisodeViewModel()
//                    let vc = EpisodeViewController(viewModel: vm)
//                    owner.navigationController?.pushViewController(vc, animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureListCell(_ item: UICollectionViewListCell, _ platforms: DramaPlatform) -> UICollectionViewListCell {
        let cell = item
        var content = UIListContentConfiguration.valueCell()
        content.imageProperties.maximumSize = CGSize(width: 50, height: 30)
        content.image = UIImage(systemName: "photo")
        
        let baseURL = Config.shared.secureURL + Config.LogoSizes.w92.rawValue
        let urlString = baseURL + platforms.image
        
        guard let url = URL(string: urlString) else { return UICollectionViewListCell() }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                var updatedContent = cell.contentConfiguration as? UIListContentConfiguration
                updatedContent?.image = image
                cell.contentConfiguration = updatedContent
            }
        }.resume()
        
        cell.contentConfiguration = content
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = .darkGray
        backgroundConfig.cornerRadius = 10
        backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        cell.backgroundConfiguration = backgroundConfig
        cell.accessories = [.disclosureIndicator(options: .init(tintColor: .baseWhite))]
        return cell
    }
    
}

