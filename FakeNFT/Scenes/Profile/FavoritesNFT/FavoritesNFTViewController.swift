//
//  FavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by MacBook on 01.06.2023.
//

import UIKit

class FavoritesNFTViewController: UIViewController {
    
    // MARK: - Properties
    private let profileService: ProfileService
    private var favoriteNfts: [NFT] = []
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoritesNFTCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesNFTCollectionViewCell.identifier)
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
    init(profileService: ProfileService) {
        self.profileService = profileService
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
        getFavoritesNfts()
        layout()
        updateView()
    }
    
    // MARK: - Methods
    private func getFavoritesNfts() {
        profileService.getFavoritesNFT { [weak self] result in
            switch result{
            case .success(let myNfts):
                self?.favoriteNfts = myNfts
                self?.updateView()
            case .failure:
                return
            }
        }
    }
    
    private func setNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    private func updateView() {
        nftCollectionView.reloadData()
        nftCollectionView.isHidden = favoriteNfts.isEmpty
        placeholderLabel.isHidden = !favoriteNfts.isEmpty
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
extension FavoritesNFTViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteNfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesNFTCollectionViewCell.identifier, for: indexPath) as! FavoritesNFTCollectionViewCell
        let nft = favoriteNfts[indexPath.row]
        cell.setupCell(with: nft)
        cell.likeButtonAction = { [weak self] in
            self?.favoriteNfts.remove(at: indexPath.row)
            self?.nftCollectionView.reloadData()
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
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
