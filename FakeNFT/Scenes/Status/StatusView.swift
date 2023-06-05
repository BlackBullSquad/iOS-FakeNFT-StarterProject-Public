import UIKit
import Combine

final class StatusView: UIViewController {
    private let viewModel: StatusViewModel
    private var cancellable: AnyCancellable?

    init(_ viewModel: StatusViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        cancellable = viewModel.bind { [weak self] in self?.viewModelDidUpdate() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.continueLabel, for: .normal )
        button.setTitleColor(.asset(.white), for: .normal)
        button.titleLabel?.font = .asset(.bold17)
        button.backgroundColor = .asset(.black)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.statusDescription
        label.textColor = .asset(.black)
        label.font = .asset(.bold22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var statusImage = UIImageView(
        image: UIImage(named: viewModel.imageAsset)
    )
}

// MARK: - Lifecycle

extension StatusView {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func viewModelDidUpdate() {
        if !viewModel.isPresented {
            dismiss(animated: true)
        }
    }
}

// MARK: - Initial Setup

private extension StatusView {
    func setupViews() {
        view.backgroundColor = .asset(.white)

        let vStack = UIStackView(arrangedSubviews: [statusImage, infoLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false

        let guide = view.safeAreaLayoutGuide

        view.addSubview(vStack)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - User Actions

private extension StatusView {
    @objc func didTapContinueButton() {
        viewModel.didContinue()
    }
}
