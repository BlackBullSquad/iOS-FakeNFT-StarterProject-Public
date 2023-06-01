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

    private lazy var infoLabel: UILabel = {
        let label = UILabel()

        let line1 = NSMutableAttributedString(string: "Совершая покупку, вы соглашаетесь с условиями\n")
        let line2Attributes = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
        let line2 = NSAttributedString(string: "Пользовательского соглашения", attributes: line2Attributes)
        line1.append(line2)

        label.attributedText = line1
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular13)
        label.textAlignment = .center
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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

        view.addSubview(infoLabel)
        view.addSubview(purchaseButton)

        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: -20),
            infoLabel.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor),
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
