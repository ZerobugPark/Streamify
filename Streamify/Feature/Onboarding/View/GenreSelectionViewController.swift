//
//  GenreSelectionViewController.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class GenreSelectionViewController: UIViewController {

    weak var coordinator: OnboardingCoordinator?
    var userName: String?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 피드에서 보고싶은 관심 장르"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 순서대로 반영돼요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.id)
        return collectionView
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 장르는 나중에 다시 수정할 수 있어요"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()

    private let disposeBag = DisposeBag()
    private var viewModel: GenreSelectionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureViewModel()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(collectionView)
        view.addSubview(infoLabel)
        view.addSubview(doneButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(infoLabel.snp.top).offset(-16)
        }

        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(doneButton.snp.top).offset(-12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }

    private func configureViewModel() {
        let genres = Config.Genres.allCases.map { Genre(id: $0.rawValue, name: $0.genre) }
        viewModel = GenreSelectionViewModel(genres: genres)
    }

    private func bindViewModel() {
        collectionView.dataSource = self

        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let genre = self.viewModel.genreList()[indexPath.item]
                self.viewModel.didSelectGenre.accept(genre)
            })
            .disposed(by: disposeBag)

        collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let genre = self.viewModel.genreList()[indexPath.item]
                self.viewModel.didDeselectGenre.accept(genre)
            })
            .disposed(by: disposeBag)

        viewModel.selectedGenres
            .bind(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.isSelectionValid
            .drive(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isSelectionValid
            .map { $0 ? UIColor.systemBlue : UIColor.lightGray }
            .drive(doneButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let selected = self.viewModel.selectedGenres.value
                let selectedIDs = selected.map { $0.id }
                UserDefaults.standard.set(self.userName, forKey: "userName")
                UserDefaults.standard.set(selectedIDs, forKey: "preferredGenres")
                UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
                self.coordinator?.finishOnboarding()
            }
            .disposed(by: disposeBag)
    }
}

extension GenreSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.genreList().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.id, for: indexPath) as? GenreCell else {
            return UICollectionViewCell()
        }
        let genre = viewModel.genreList()[indexPath.item]
        var configuredGenre = genre
        configuredGenre.isSelected = viewModel.isGenreSelected(genre)
        cell.configure(with: configuredGenre)
        return cell
    }
}
