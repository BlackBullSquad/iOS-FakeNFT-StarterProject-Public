import UIKit

final class RatingView: UIView {

    private let star1 = UIImageView()
    private let star2 = UIImageView()
    private let star3 = UIImageView()
    private let star4 = UIImageView()
    private let star5 = UIImageView()

    var rating: Int? { didSet { configure(with: rating) } }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

// MARK: - Setup

extension RatingView {
    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [star1, star2, star3, star4, star5])
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

        star1.image = UIImage(named: rating > 0 ? "ratingStarActive" : "ratingStarInactive")
        star2.image = UIImage(named: rating > 1 ? "ratingStarActive" : "ratingStarInactive")
        star3.image = UIImage(named: rating > 2 ? "ratingStarActive" : "ratingStarInactive")
        star4.image = UIImage(named: rating > 3 ? "ratingStarActive" : "ratingStarInactive")
        star5.image = UIImage(named: rating > 4 ? "ratingStarActive" : "ratingStarInactive")
    }
}
