//
//  SearchViewController.swift
//  Streamify
//
//  Created by 조다은 on 2025/03/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - UI Components
    
    private let searchBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "작품, 인물 등"
        textField.textColor = .white
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let verticalListView = VerticalListView()
    private let disposeBag = DisposeBag()

    private let searchQuery = PublishRelay<String>()
    private let searchResults = BehaviorRelay<[SearchResult]>(value: [])
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black
        setupLayout()
        setupNavigation()
        setupCollectionView()
        bind()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.addSubview(searchBarContainerView)
        searchBarContainerView.addSubview(searchIconImageView)
        searchBarContainerView.addSubview(searchTextField)
        view.addSubview(cancelButton)
        view.addSubview(verticalListView)
        
        searchBarContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-8)
            make.height.equalTo(36)
        }
        
        searchIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(20)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBarContainerView)
            make.trailing.equalToSuperview().inset(16)
        }
        
        verticalListView.snp.makeConstraints { make in
            make.top.equalTo(searchBarContainerView.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigation() {
        let title = "검색"
        navigationItem.title = title
        navigationItem.backButtonTitle = ""
    }
    
    // MARK: - Setup & Binding
    
    private func setupCollectionView() {
        verticalListView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        verticalListView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bind() {
        // 텍스트 입력 이벤트
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
            .bind(to: searchQuery)
            .disposed(by: disposeBag)
        
        // 검색 실행
        searchQuery
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[SearchResult]> in
                guard !query.isEmpty else { return .just([]) }
                
                return NetworkManager.shared.request(api: .search(query: query), type: TMDBResponse.self)
                    .map { result in
                        switch result {
                        case .success(let data): return data.results
                        case .failure: return []
                        }
                    }
                    .asObservable()
                    .catch { _ in .just([]) }
            }
            .bind(to: searchResults)
            .disposed(by: disposeBag)
        
        // 결과 바인딩
        searchResults
            .bind(to: verticalListView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.id, cellType: SearchCollectionViewCell.self)) { row, item, cell in
                cell.configure(with: item.posterPath)
            }
            .disposed(by: disposeBag)
        
        verticalListView.collectionView.rx.modelSelected(SearchResult.self)
            .bind(with: self) { owner, selectedItem in
                owner.coordinator?.showDetail(for: selectedItem)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = view.frame.width
        let spacing: CGFloat = 10
        let inset: CGFloat = 8
        let itemWidth = (deviceWidth - ((spacing * 2) + (inset * 2))) / 3
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
}
