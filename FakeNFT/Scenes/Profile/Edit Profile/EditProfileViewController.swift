//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by MacBook on 31.05.2023.
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {
  
    private let nftApi: NftAPI = FakeNftAPI()
    private var nfts: [Int] = []
    private var likes: [Int] = []
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor.asset(Asset.main(.backround))
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.asset(Asset.main(.backround))
        label.numberOfLines = 0
        return label
    }()

    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor.asset(Asset.main(.backround))
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        return textField
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 70/2
        image.clipsToBounds = true
        return image
    }()

    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
        return label
    }()

    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor.asset(Asset.main(.backround))
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        return textField
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
        let button = UIBarButtonItem(image: UIImage(named: "editProfile"), style: .plain, target: self, action: #selector(self.editProfile))
        button.tintColor = .label
        navigationItem.setRightBarButtonItems([button], animated: true)
    }
    
    @objc private func editProfile() {
        print("Edit profile")
    }
    
    private func getProfile() {
        nftApi.getProfile { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.setupView(profile: profile)
                    self?.nfts = profile.nfts
                    self?.likes = profile.likes
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
         urlLabel
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
            urlLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12)
        ])
    }
}

