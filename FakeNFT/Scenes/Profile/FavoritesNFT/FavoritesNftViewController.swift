//
//  FavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by MacBook on 01.06.2023.
//

import UIKit

class FavoritesNftViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: FavoritesNftViewModel
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoritesNftCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesNftCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.text = "У Вас ещё нет избранных NFT"
        return label
    }()
    
    // MARK: - Initialiser
    init(viewModel: FavoritesNftViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранные NFT"
        view.backgroundColor = .systemBackground
        setNavBar()
        layout()
        bind()
        initialization()
    }
    
    // MARK: - Methods
    private func setNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    private func initialization() {
        updateView()
    }
    
    private func bind() {
        viewModel.favoriteNftsDidChange = { [weak self] in
            self?.updateView()
        }
        viewModel.showErrorAlertStateDidChange = { [weak self] in
            if let needShow = self?.viewModel.showErrorAlertState, needShow {
                self?.showErrorAlert {
                    self?.viewModel.initialization()
                }
            }
        }
    }
    
    private func updateView() {
        nftCollectionView.reloadData()
        nftCollectionView.isHidden = viewModel.favoriteNfts.isEmpty
        placeholderLabel.isHidden = !viewModel.favoriteNfts.isEmpty
    }
    
    private func showErrorAlert(action: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Ошибка загрузки данных",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            action()
        }

        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func layout() {
        [nftCollectionView, placeholderLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesNftViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoriteNfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesNftCollectionViewCell.identifier, for: indexPath) as! FavoritesNftCollectionViewCell
        let nft = viewModel.favoriteNfts[indexPath.row]
        cell.setupCell(with: nft)
        cell.likeButtonAction = { [weak self] in
            self?.viewModel.likeButtonHandle(indexPath: indexPath)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesNftViewController: UICollectionViewDelegateFlowLayout {
    private var lineSpacing: CGFloat { return 20 }
    private var interitemSpacing: CGFloat { return 7 }
    private var sideInset: CGFloat { return 16 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - interitemSpacing - 2 * sideInset) / 2
        return CGSize(width: width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interitemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: sideInset, bottom: 20, right: sideInset)
    }
}
