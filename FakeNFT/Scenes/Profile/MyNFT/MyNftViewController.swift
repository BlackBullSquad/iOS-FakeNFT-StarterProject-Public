//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by MacBook on 01.06.2023.
//

import UIKit

enum SortDescriptor: String {
    case price
    case name
    case rating
}

class MyNftViewController: UIViewController {
    
    // MARK: - Properties
    private let profileService: ProfileService
    private let settingsStorage: SettingsStorageProtocol
    private let profile: Profile
    private var myNfts: [Nft] = []
    private var likes: [Int] = []
    
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: MyNftTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Initialiser
    init(profileService: ProfileService, profile: Profile, settingsStorage: SettingsStorageProtocol) {
        self.profileService = profileService
        self.profile = profile
        self.settingsStorage = settingsStorage
        self.likes = profile.likes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои NFT"
        view.backgroundColor = .systemBackground
        setNavBar()
        getMyNfts(with: profile)
        layout()
    }
    
        // MARK: - Methods
        private func getMyNfts(with: Profile) {
            profileService.getMyNft(with: profile) { [weak self] result in
                switch result{
                case .success(let myNfts):
                    self?.myNfts = myNfts
                    self?.sortInit()
                    self?.nftTableView.reloadData()
                case .failure:
                    return
                }
            }
        }
    private func setNavBar() {
        // Additional bar button items
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = " "
        let button = UIBarButtonItem(image: UIImage(named: "sortIcon"), style: .plain, target: self, action: #selector(sortNft))
        navigationItem.setRightBarButtonItems([button], animated: true)
    }
    
    @objc private func sortNft() {
        showAlert()
    }
    
    private func sortInit() {
        if let descriptor = settingsStorage.fetchSorting() {
            sort(by: descriptor)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet)
        
        let actionFirst = UIAlertAction(title: "По цене", style: .default) { [weak self] (_) in
            self?.sort(by: .price)
        }
        alert.addAction(actionFirst)
        let actionSecond = UIAlertAction(title: "По Рейтингу", style: .default) { [weak self] (_) in
            self?.sort(by: .rating)
        }
        alert.addAction(actionSecond)
        let actionThird = UIAlertAction(title: "По Названию", style: .default) { [weak self] (_) in
            self?.sort(by: .name)
        }
        alert.addAction(actionThird)
        let actionCancel = UIAlertAction(title: "Закрыть", style: .cancel)
        alert.addAction(actionCancel)
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func sort(by descriptor: SortDescriptor) {
        switch descriptor {
        case .price:
            myNfts.sort(by: { $0.price < $1.price } )
        case .name:
            myNfts.sort(by: { $0.name < $1.name } )
        case .rating:
            myNfts.sort(by: { $0.rating < $1.rating } )
        }
        settingsStorage.saveSorting(descriptor)
        nftTableView.reloadData()
    }
    
    private func layout() {
        [nftTableView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myNfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyNftTableViewCell.identifier, for: indexPath) as! MyNftTableViewCell
        let myNft = myNfts[indexPath.row]
        let isLiked = likes.contains(myNft.id)
        cell.setupCell(with: myNft, isLiked: isLiked)
        cell.likeButtonAction = { [weak self] in
            self?.likeButtonHandle(indexPath: indexPath)
        }
        return cell
    }
    
    private func likeButtonHandle(indexPath: IndexPath) {
        let idNftLikeChange = myNfts[indexPath.row].id
        if likes.contains(idNftLikeChange) {
            likes.removeAll { $0 == idNftLikeChange }
        } else {
            likes.append(idNftLikeChange)
        }
        let newProfile = Profile(
            id: profile.id,
            name: profile.name,
            description: profile.description,
            avatar: profile.avatar,
            website: profile.website,
            nfts: profile.nfts,
            likes: likes
        )
        nftTableView.reloadData()
        profileService.updateProfile(newProfile)
    }
    
}

// MARK: - UITableViewDelegate
extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

