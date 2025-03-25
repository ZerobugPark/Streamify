//
//  DetailCoordintaor.swift
//  Streamify
//
//  Created by 조다은 on 3/24/25.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let id: Int

    init(navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.id = id
    }

    func start() {
        showDetailScreen()
    }

    private func showDetailScreen() {
        let detailVC = DramaViewController(viewModel: DramaViewModel(dramaID: id))
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: true)
    }

    func showEpisodeList(_ episode: DramaEpisode, _ seasonIndex: Int) {
        let episodeVC = EpisodeViewController(item: episode, seasonIndex: seasonIndex)
        episodeVC.coordinator = self
        navigationController.pushViewController(episodeVC, animated: true)
    }

//    func showStarRating() {
//        let starRatingVC = StarRatingStorageViewController(viewModel: StarRatingStorageViewModel())
//        navigationController.pushViewController(starRatingVC, animated: true)
//    }
}
