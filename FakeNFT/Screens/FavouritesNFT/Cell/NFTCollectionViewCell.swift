//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by mpplokhov on 29.07.2025.
//

import UIKit

final class NFTCollectionViewCell: UICollectionViewCell {

    static let identifier = "NFTCollectionViewCell"

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .heartActive)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor.segmentActive
        label.textAlignment = .left
        return label
    }()

    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()

    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(heartImageView)
        contentView.addSubview(labelsStack)

        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(ratingStack)
        labelsStack.addArrangedSubview(priceLabel)

        imageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        heartImageView.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.trailing.equalTo(imageView)
            make.size.equalTo(30)
        }

        labelsStack.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(imageView.snp.centerY)
        }

        ratingStack.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
    }

    func configure(with model: NFTModel) {
        nameLabel.text = model.name
        priceLabel.text = String(format: NSLocalizedString("Profile.myNFT.price", comment: ""), model.price)
        imageView.kf.setImage(with: model.imageURL)
        updateRating(model.rating)
    }

    private func updateRating(_ rating: Int) {
        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<5 {
            let star = UIImageView(image: UIImage(resource: i < rating ? .starDone : .starNoActive))
            star.contentMode = .scaleAspectFit
            star.snp.makeConstraints { $0.size.equalTo(12) }
            ratingStack.addArrangedSubview(star)
        }
    }
}
