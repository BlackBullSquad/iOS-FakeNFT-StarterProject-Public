import UIKit

final class RatingView: UIView {

    private var stars: [UIImageView]

    var rating: Int? { didSet { configure(with: rating) } }

    // MARK: - Initializers

    override init(frame: CGRect) {
        self.stars = (1...5).map { _ in
            let view = UIImageView()
            view.image = .asset(.ratingStar)
            return view
        }

        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension RatingView {
    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: stars)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        configure(with: nil)
    }
}

// MARK: - Configuration

extension RatingView {
    private func configure(with rating: Int?) {
        let rating = rating ?? 0

        stars.enumerated().forEach { offset, star in
            star.tintColor = rating > offset ? .asset(.yellowUniversal) : .asset(.lightGrey)
        }
    }
}
