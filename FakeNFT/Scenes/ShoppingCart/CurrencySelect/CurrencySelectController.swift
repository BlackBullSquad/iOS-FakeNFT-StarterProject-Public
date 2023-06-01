import UIKit

final class CurrencySelectController: UIViewController {
    let currencies: [Currency]
    var onPurchase: () -> Void

    init(currencies: [Currency], onPurchase: @escaping () -> Void) {
        self.currencies = currencies
        self.onPurchase = onPurchase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .asset(.bold17)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var infoText: UIStackView = {
        let firstLine = UILabel()
        firstLine.text = "Совершая покупку, вы соглашаетесь с условиями"
        firstLine.textColor = .asset(.main(.primary))
        firstLine.font = .asset(.regular13)
        firstLine.textAlignment = .left

        let secondLine = UILabel()
        secondLine.text = "Пользовательского соглашения"
        secondLine.textColor = .asset(.additional(.blue))
        secondLine.font = .asset(.regular13)
        secondLine.textAlignment = .left

        let vStack = UIStackView(arrangedSubviews: [firstLine, secondLine])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false

        return vStack
    }()
}

// MARK: - Setup

extension CurrencySelectController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        title = "Выберите способ оплаты"
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .black

        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        view.backgroundColor = .white

        let guide = view.safeAreaLayoutGuide

        view.addSubview(infoText)
        view.addSubview(purchaseButton)

        NSLayoutConstraint.activate([
            infoText.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -20),
            infoText.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor),
            infoText.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor),
            purchaseButton.heightAnchor.constraint(equalToConstant: 60),
            purchaseButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            purchaseButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            purchaseButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Actions

extension CurrencySelectController {
    @objc func didTapPurchaseButton() {
        onPurchase()
    }
}
