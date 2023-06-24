import UIKit

final class DescriptionCellView: UICollectionViewCell {

    static let identifier = "DescriptionCell"

    var viewModel: DescriptionCellViewModel? {
        didSet {
            didUpdateViewModel()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold22)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular13)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.additional(.blue))
        label.font = .asset(.regular15)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false

        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAuthorTap))
        label.addGestureRecognizer(tap)

        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular13)
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var insideStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorLabel, authorLinkLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, insideStack, textLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: DescriptionCellViewModel) {
        self.viewModel = viewModel
    }

    private func didUpdateViewModel() {
        titleLabel.text = viewModel?.title
        authorLabel.text = "Автор:"
        authorLinkLabel.text = viewModel?.author
        textLabel.text = viewModel?.description
    }

    @objc private func handleAuthorTap() {
        guard let authorURL = viewModel?.authorURL else { return }
        viewModel?.authorLinkTapped(authorURL)
    }
}
