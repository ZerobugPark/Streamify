//
//  DetailCoordintaor.swift
//  Streamify
//
//  Created by 조다은 on 3/24/25.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let mediaItem: MediaItem

    init(navigationController: UINavigationController, mediaItem: MediaItem) {
        self.navigationController = navigationController
        self.mediaItem = mediaItem
    }

    func start() {
        showDetailScreen()
    }

    private func showDetailScreen() {
        let detailVC = DramaViewController(viewModel: DramaViewModel(dramaID: mediaItem.id))
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: true)
    }

    func showEpisodeList(_ episode: DramaEpisode) {
        let episodeVC = EpisodeViewController(viewModel: EpisodeViewModel(item: episode))
        episodeVC.coordinator = self
        navigationController.pushViewController(episodeVC, animated: true)
    }

    func showStarRating() {
        let starRatingVC = StarRatingStorageViewController(viewModel: StarRatingStorageViewModel())
        navigationController.pushViewController(starRatingVC, animated: true)
    }
}
