import UIKit

final class DeleteController: UIViewController {
    let avatarURL: URL
    let onDelete: () -> Void

    init(avatarURL: URL, onDelete: @escaping () -> Void) {
        self.onDelete = onDelete
        self.avatarURL = avatarURL

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var avatar: NFTAvatarView = {
        let avatar = NFTAvatarView()
        avatar.viewModel = .init(imageSize: .large, imageURL: avatarURL, likeButtonAction: nil)
        return avatar
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.asset(.main(.red)), for: .normal)
        button.titleLabel?.font = .asset(.regular17)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .asset(.regular17)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = """
            Вы уверены, что хотите
            удалить объект из корзины?
            """
        label.numberOfLines = 0
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular13)
        label.textAlignment = .center
        return label
    }()
}

// MARK: - Lifecycle

extension DeleteController {
    override func viewDidLoad() {
        setupViews()
    }
}

// MARK: - Layout

extension DeleteController {
    func setupViews() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(blurEffectView)

        let buttonStack = UIStackView(arrangedSubviews: [deleteButton, cancelButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8

        let vStack = UIStackView(arrangedSubviews: [avatar, questionLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 12

        let panel = UIStackView(arrangedSubviews: [vStack, buttonStack])
        panel.axis = .vertical
        panel.spacing = 20

        panel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(panel)

        NSLayoutConstraint.activate([
            panel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
}

// MARK: - Actions

extension DeleteController {
    @objc func didTapDeleteButton() {
        onDelete()
        dismiss(animated: true)
    }

    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
}
