import UIKit

final class PurchaseStatusController: UIViewController {
    let isSuccess: Bool
    var onContinue: (() -> Void)?

    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            isSuccess ? "Вернуться в каталог" : "Попробовать еще раз",
            for: .normal
        )
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .asset(.bold17)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = isSuccess
        ? "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        : "Упс! Что-то пошло не так :(\nПопробуйте ещё раз!"

        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var statusImage = UIImageView(
        image: UIImage(named: isSuccess ? "purchaseSuccess" : "purchaseFailure")
    )
}

// MARK: - Setup

extension PurchaseStatusController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .white

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

// MARK: - Actions

extension PurchaseStatusController {
    @objc func didTapContinueButton() {
        onContinue?()
        dismiss(animated: true)
    }
}
