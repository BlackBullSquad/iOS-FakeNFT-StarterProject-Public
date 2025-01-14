import UIKit
import Combine

final class NftDeleteView: UIViewController {
    private let viewModel: NftDeleteViewModel
    private var cancellable: AnyCancellable?

    init(_ viewModel: NftDeleteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        cancellable = viewModel.bind { [weak self] in self?.viewModelDidUpdate() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var avatar: NftAvatarView = {
        let avatar = NftAvatarView()
        avatar.viewModel = .init(imageURL: viewModel.avatarURL, likeButtonAction: nil)
        return avatar
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.asset(.redUniversal), for: .normal)
        button.titleLabel?.font = .asset(.regular17)
        button.backgroundColor = .asset(.black)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.asset(.white), for: .normal)
        button.titleLabel?.font = .asset(.regular17)
        button.backgroundColor = .asset(.black)
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
        label.textColor = .asset(.black)
        label.font = .asset(.regular13)
        label.textAlignment = .center
        return label
    }()
}

// MARK: - Lifecycle

extension NftDeleteView {
    override func viewDidLoad() {
        setupViews()
    }

    private func viewModelDidUpdate() {
        if !viewModel.isPresented {
            dismiss(animated: true)
        }
    }
}

// MARK: - Initial Setup

private extension NftDeleteView {
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
            avatar.heightAnchor.constraint(equalToConstant: 108),
            avatar.widthAnchor.constraint(equalToConstant: 108),
            panel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
}

// MARK: - User Actions

private extension NftDeleteView {
    @objc func didTapDeleteButton() {
        viewModel.didDelete()
    }

    @objc func didTapCancelButton() {
        viewModel.didCancel()
    }
}
