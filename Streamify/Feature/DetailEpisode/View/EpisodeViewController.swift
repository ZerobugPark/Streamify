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
import RealmSwift

final class EpisodeViewController: BaseViewController<EpisodeView, EpisodeViewModel> {
    
    weak var coordinator: DetailCoordinator?
    typealias collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<EpisodeSectionModel>
    private let repository: any Repository = RealmRepository()
    private let episode: DramaEpisode
    private let seasonIndex: Int
    
    init(item: DramaEpisode, seasonIndex: Int) {
        self.episode = item
        self.seasonIndex = seasonIndex
        super.init(viewModel: EpisodeViewModel(item: item))
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dataSource = collectionViewDataSource(configureCell: { dataSource, collectionView, indexPath, item in
        switch item {
        case .header(let header):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeHeaderCell.id, for: indexPath) as! EpisodeHeaderCell
            cell.configure(header)
            return cell
        case .button:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeButtonCell.id, for: indexPath) as! EpisodeButtonCell
            
            cell.configure(self.episode.dramaTable.seasons[self.seasonIndex].episodes, self.seasonIndex, self.episode.dramaTable.seasons[self.seasonIndex], self.episode.dramaTable)
            
            return cell
        case .episode(let item):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.id, for: indexPath) as! EpisodeCell
            cell.configure(item,  self.episode.dramaTable.seasons[self.seasonIndex].episodes[indexPath.item])
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
        repository.getFileURL()
    }
    
    override func bindViewModel() {
        
        let input = EpisodeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.sectionModel
            .drive(mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }

}
extension List {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
