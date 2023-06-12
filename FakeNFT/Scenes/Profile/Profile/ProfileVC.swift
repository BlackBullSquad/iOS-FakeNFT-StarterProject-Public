import UIKit
import Kingfisher

final class ProfileVC: UIViewController {
    
    private let profileService: ProfileService
    private let settingsStorage: SettingsStorageProtocol
    private var profile: Profile?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 70/2
        image.clipsToBounds = true
        return image
    }()
    
    private let urlTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showWebView), for: .touchUpInside)
        return button
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

    // MARK: - Initialiser
    init(profileService: ProfileService, settingsStorage: SettingsStorageProtocol) {
        self.profileService = profileService
        self.settingsStorage = settingsStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavBar()
        getProfile()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfile()
    }
    
    private func setNavBar() {
        // Additional bar button items
        let button = UIBarButtonItem(image: UIImage(named: "editProfile"), style: .plain, target: self, action: #selector(editProfile))
        button.tintColor = .label
        navigationItem.setRightBarButtonItems([button], animated: true)
    }
    
    @objc private func showWebView() {
        guard let url = profile?.website else { return }
        let webView = WebView(url: url)
        present(webView, animated: true)
    }
    
    @objc private func editProfile() {
        guard let profile = profile else { return }
        let editProfileVC = UINavigationController(rootViewController: EditProfileViewController(profile: profile, profileService: profileService))
        present(editProfileVC, animated: true)
    }
    
    private func getProfile() {
        profileService.getUser { [weak self] result in
            switch result{
            case .success(let profile):
                self?.profile = profile
                self?.setupView(profile: profile)
            case .failure:
                return
            }
        }
    }
    
    private func setupView(profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        urlTextButton.setTitle(profile.website.absoluteString, for: .normal)
        profileImage.kf.setImage(with: profile.avatar)
        profileTableView.reloadData()
    }

    private func layout() {
        [nameLabel,
         profileImage,
         descriptionLabel,
         urlTextButton,
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

            descriptionLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            urlTextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            urlTextButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            urlTextButton.heightAnchor.constraint(equalToConstant: 30),

            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.topAnchor.constraint(equalTo: urlTextButton.bottomAnchor, constant: 44),
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
        case 0: labelString = "Мои NFT (\(profile?.nfts.count ?? 0))"
        case 1: labelString = "Избранные NFT (\(profile?.likes.count ?? 0))"
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
        switch indexPath.row {
        case 0: showMyNftVC()
        case 1: navigationController?.pushViewController(FavoritesNftViewController(profileService: profileService), animated: true)
        default:
            return
        }
    }
    
    private func showMyNftVC() {
        guard let profile = profile else { return }
        navigationController?.pushViewController(MyNftViewController(profileService: profileService, profile: profile, settingsStorage: settingsStorage), animated: true)
    }
}
    
