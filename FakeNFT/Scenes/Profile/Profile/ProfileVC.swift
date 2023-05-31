import UIKit
import Kingfisher

final class ProfileVC: UIViewController {
  
    private let nftApi: NftAPI = FakeNftAPI()
    private var profile: ProfileDTO?
    private var nfts: [Int] = []
    private var likes: [Int] = []
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.asset(Asset.main(.backround))
        label.numberOfLines = 0
        return label
    }()

    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 70/2
        image.clipsToBounds = true
        return image
    }()

    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.asset(Asset.main(.backround))
        return label
    }()

    private lazy var profileTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavBar()
        getProfile()
        layout()
    }

    private func setNavBar() {
        // Additional bar button items
        let button = UIBarButtonItem(image: UIImage(named: "editProfile"), style: .plain, target: self, action: #selector(editProfile))
        button.tintColor = UIColor.asset(Asset.main(.backround))
        navigationItem.setRightBarButtonItems([button], animated: true)
    }
    
    @objc private func editProfile() {
        print("Edit profile")
        guard let profile = profile else { return }
        let editProfileVC = UINavigationController(rootViewController: EditProfileViewController(profile: profile, nftApi: nftApi))
        present(editProfileVC, animated: true)
    }
    
    private func getProfile() {
        nftApi.getProfile { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.setupView(profile: profile)
                    self?.nfts = profile.nfts
                    self?.likes = profile.likes
                    self?.profileTableView.reloadData()
                    self?.profile = profile
                }
                print(profile)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupView(profile: ProfileDTO) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        urlLabel.text = profile.website.absoluteString
        profileImage.kf.setImage(with: profile.avatar)
    }

    private func layout() {
        [nameLabel,
         profileImage,
         descriptionLabel,
         urlLabel,
         profileTableView
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 13),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),

            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 44),
            profileTableView.heightAnchor.constraint(equalToConstant: 375*3),
        ])
    }
}

// MARK: - UITableViewDataSource
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        var labelString = ""
        switch indexPath.row {
        case 0: labelString = "Мои NFT (\(nfts.count))"
        case 1: labelString = "Избранные NFT (\(likes.count))"
        case 2: labelString = "О разработчике"
        default:
            labelString = ""
        }
        cell.setupCell(label: labelString)
        return cell
    }

}

// MARK: - UITableViewDelegate
extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
    
