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
    private let profileService: ProfileService
    private let profile: Profile
    
    private var name: String
    private var descript: String
    private var avatar: URL
    private var website: URL
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Имя"
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = "Описание"
        return label
    }()

    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
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
        label.textColor = .label
        label.text = "Сайт"
        return label
    }()

    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = UIColor.asset(Asset.main(.lightGray))
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private let changeAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сменить\nфото", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.asset(Asset.main(.background))
        button.layer.cornerRadius = 70/2
        button.clipsToBounds = true
        button.addTarget(EditProfileViewController.self, action: #selector(changeAvatarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialiser
    init(profile: Profile, profileService: ProfileService) {
        self.profile = profile
        self.profileService = profileService
        self.name = profile.name
        self.descript = profile.description
        self.avatar = profile.avatar
        self.website = profile.website
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
    @objc private func changeAvatarButtonTapped() {
        showAlert()
    }
    
    private func showAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Сменить автар", message: "Введите новый URL", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            if let text = alert.textFields?[0].text, let url = URL(string: text) {
                self?.avatar = url
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setNavBar() {
        // Additional bar button items
        let button = UIBarButtonItem(image: UIImage(named: "clouse"), style: .plain, target: self, action: #selector(clouseEditProfile))
        button.tintColor = .label
        let buttonSecond = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveProfile))
        buttonSecond.tintColor = .label
        navigationItem.setRightBarButtonItems([button, buttonSecond], animated: true)
    }
    
    @objc private func saveProfile() {
        name = nameTextField.text ?? ""
        descript = descriptionTextField.text ?? ""
        if let text = urlTextField.text, let url = URL(string: text) {
            website = url
        }
        let newProfile = Profile(id: profile.id, name: name, description: descript, avatar: avatar, website: website, nfts: profile.nfts, likes: profile.likes)
        
        profileService.updateProfile(newProfile)
        dismiss(animated: true)
    }
    
    @objc private func clouseEditProfile() {
        dismiss(animated: true)
    }
    
    private func setupView(profile: Profile) {
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
         urlTextField,
         changeAvatarButton
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),

            changeAvatarButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            changeAvatarButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            changeAvatarButton.heightAnchor.constraint(equalToConstant: 70),
            changeAvatarButton.widthAnchor.constraint(equalToConstant: 70),
            
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

