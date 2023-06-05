import UIKit
import Combine

final class PurchaseStatusView: UIViewController {
    private let viewModel: PurchaseStatusViewModel
    private var cancellable: AnyCancellable?

    init(_ viewModel: PurchaseStatusViewModel) {
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
        button.setTitle(
            viewModel.isSuccess ? "Вернуться в каталог" : "Попробовать еще раз",
            for: .normal
        )
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
        label.text = viewModel.isSuccess
        ? "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        : "Упс! Что-то пошло не так :(\nПопробуйте ещё раз!"

        label.textColor = .asset(.black)
        label.font = .asset(.bold22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var statusImage = UIImageView(
        image: UIImage(named: viewModel.isSuccess ? "purchaseSuccess" : "purchaseFailure")
    )
}

// MARK: - Lifecycle

extension PurchaseStatusView {
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

private extension PurchaseStatusView {
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
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - User Actions

private extension PurchaseStatusView {
    @objc func didTapContinueButton() {
        viewModel.didContinue()
    }
}
