import UIKit
import Kingfisher

final class ProfileVC: UIViewController {

    private var viewModel: ProfileViewModel

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

    private lazy var urlTextButton: UIButton = {
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
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavBar()
        initialization()
        bind()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProfile()
    }

    private func setNavBar() {
        // Additional bar button items
        let button = UIBarButtonItem(image: UIImage(named: "editProfile"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(editProfile))
        button.tintColor = .label
        navigationItem.setRightBarButtonItems([button], animated: true)
    }

    private func initialization() {
        guard let profile = viewModel.profile else { return }
        setupView(profile: profile)
    }

    private func bind() {
        viewModel.profileDidChange = { [weak self] in
            guard let profile = self?.viewModel.profile else { return }
            self?.setupView(profile: profile)
        }
        viewModel.showErrorAlertStateDidChange = { [weak self] in
            if let needShow = self?.viewModel.showErrorAlertState, needShow {
                self?.showErrorAlert {
                    self?.viewModel.getProfile()
                }
            }
        }
    }

    @objc private func showWebView() {
        guard let url = viewModel.profile?.website else { return }
        let webView = WebView(url: url)
        present(webView, animated: true)
    }

    @objc private func editProfile() {
        guard let viewController = viewModel.getEditProfileVC() else { return }
        let editProfileVC = UINavigationController(rootViewController: viewController)
        present(editProfileVC, animated: true)
    }

    private func setupView(profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        urlTextButton.setTitle(profile.website.absoluteString, for: .normal)
        profileImage.kf.setImage(with: profile.avatar)
        profileTableView.reloadData()
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
            profileTableView.heightAnchor.constraint(equalToConstant: 375*3)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.identifier,
            for: indexPath
        ) as? ProfileTableViewCell else {
            assertionFailure("Could not cast cell to ProfileTableViewCell")

            return UITableViewCell()
        }
        let titleCell = viewModel.fetchViewTitleForCell(with: indexPath)
        cell.setupCell(label: titleCell)
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
        case 0: guard let viewController = viewModel.getMyNftVC() else { return }
            navigationController?.pushViewController(viewController, animated: true)
        case 1: let viewController = viewModel.getFavoritesNftVC()
            navigationController?.pushViewController(viewController, animated: true)
        default:
            return
        }
    }

}
