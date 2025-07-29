//
//  NftTableViewCell.swift
//  FakeNFT
//
//  Created by mpplokhov on 28.07.2025.
//

import UIKit

final class NFTTableViewCell: UITableViewCell {

    static let identifier = "NFTTableViewCell"

    // MARK: - UI Elements

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .heartNoActive)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let ratingView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.setContentHuggingPriority(.required, for: .horizontal)
        stack.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stack
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor.segmentActive
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.myNFT.priceLabel", comment: "")
        label.font = UIFont.caption2
        label.textColor = UIColor.segmentActive
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()

    private let nameRatingAuthorStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private let priceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        return stack
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .leading
        return stack
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.layoutMargins = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 40
        )
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        nftImageView.addSubview(heartImageView)
        nameRatingAuthorStack.addArrangedSubview(nameLabel)
        nameRatingAuthorStack.addArrangedSubview(ratingView)
        nameRatingAuthorStack.addArrangedSubview(authorLabel)

        infoStack.addArrangedSubview(nameRatingAuthorStack)
        priceStack.addArrangedSubview(priceTitleLabel)
        priceStack.addArrangedSubview(priceLabel)

        contentStack.addArrangedSubview(infoStack)
        contentStack.addArrangedSubview(priceStack)

        [nftImageView, contentStack].forEach {
            contentView.addSubview($0)
        }

        infoStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        infoStack.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        priceStack.setContentHuggingPriority(.required, for: .horizontal)
        priceStack.setContentCompressionResistancePriority(.required, for: .horizontal)

        contentStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentStack.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        nftImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.layoutMarginsGuide.snp.leading)
            make.centerY.equalToSuperview()
            make.size.equalTo(108)
        }

        heartImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(42)
        }

        contentStack.snp.makeConstraints { make in
            make.leading.equalTo(nftImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.layoutMarginsGuide.snp.trailing)
            make.centerY.equalToSuperview()
        }

        ratingView.snp.makeConstraints { make in
            make.width.equalTo((NFTTableViewCell.STAR_SIZE * 5) + (NFTTableViewCell.STAR_SPACING * 4))
            make.height.equalTo(NFTTableViewCell.STAR_SIZE)
        }
    }

    // MARK: - Configure

    func configure(with model: NFTModel) {
        nameLabel.text = model.name
        authorLabel.text = String(format: NSLocalizedString("Profile.myNFT.authorLabel", comment: ""), model.author)
        priceLabel.text = String(format: NSLocalizedString("Profile.myNFT.price", comment: ""), model.price)
        nftImageView.kf.setImage(with: model.imageURL)
        updateRating(model.rating)
    }

    private func updateRating(_ rating: Int) {
        ratingView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for i in 0..<5 {
            let star = UIImageView(
                image: UIImage(resource: i < rating ? .starDone : .starNoActive)
            )
            star.snp.makeConstraints { $0.size.equalTo(NFTTableViewCell.STAR_SIZE) }
            ratingView.addArrangedSubview(star)
        }
    }
    
    private static let STAR_SIZE: CGFloat = 14
    private static let STAR_SPACING: CGFloat = 2
}
