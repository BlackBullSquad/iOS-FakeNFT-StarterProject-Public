//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by MacBook on 31.05.2023.
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {
  
    // MARK: - Properties
    private let nftApi: NftAPI
    private let profile: ProfileDTO
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
        label.text = "Имя"
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor.asset(Asset.main(.backround))
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
        label.text = "Описание"
        return label
    }()

    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor.asset(Asset.main(.backround))
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        textField.layer.cornerRadius = 12
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
        label.text = "Сайт"
        return label
    }()

    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor.asset(Asset.main(.backround))
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private let changeAvatarButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Initialiser
    init(profile: ProfileDTO, nftApi: NftAPI) {
        self.profile = profile
        self.nftApi = nftApi
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavBar()
        setupView(profile: profile)
        layout()
    }

    // MARK: - Methods
    private func setNavBar() {
        // Additional bar button items
        let button = UIBarButtonItem(image: UIImage(named: "clouse"), style: .plain, target: self, action: #selector(clouseEditProfile))
        button.tintColor = UIColor.asset(Asset.main(.backround))
        let buttonSecond = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveProfile))
        buttonSecond.tintColor = UIColor.asset(Asset.main(.backround))
        navigationItem.setRightBarButtonItems([button, buttonSecond], animated: true)
    }
    
    @objc private func saveProfile() {
        print("saveProfile")
    }
    
    @objc private func clouseEditProfile() {
        dismiss(animated: true)
    }
    
    private func setupView(profile: ProfileDTO) {
        nameTextField.text = profile.name
        descriptionTextField.text = profile.description
        urlTextField.text = profile.website.absoluteString
        profileImage.kf.setImage(with: profile.avatar)
    }

    private func layout() {
        [nameLabel,
         nameTextField,
         profileImage,
         descriptionLabel,
         descriptionTextField,
         urlLabel,
         urlTextField
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 19),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            
            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

