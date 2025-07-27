//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by mpplokhov on 24.07.2025.
//

import UIKit

final class EditProfileViewController: UIViewController {

    // MARK: - Properties

    private let presenter: EditProfilePresenterProtocol

    // MARK: - UI Elements

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let changePhotoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.edit.photo.change", comment: "")
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.textOnPrimary
        label.font = UIFont.medium10
        return label
    }()

    private let nameTitleLabel = EditProfileViewController.makeTitleLabel(
        NSLocalizedString("Profile.edit.name.title", comment: "")
    )
    private let nameTextView = EditProfileViewController.makeTextView()

    private let descriptionTitleLabel = EditProfileViewController.makeTitleLabel(
        NSLocalizedString("Profile.edit.description.title", comment: "")
    )
    private let descriptionTextView = EditProfileViewController.makeTextView()

    private let linkTitleLabel = EditProfileViewController.makeTitleLabel(
        NSLocalizedString("Profile.edit.link.title", comment: "")
    )
    private let linkTextView = EditProfileViewController.makeTextView()

    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Init

    init(presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar()
        setupUI()
        setupLayout()
        fillInitialValues()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(saveAndClose)
        )
    }

    private func setupUI() {
        descriptionTextView.delegate = self
        nameTextView.delegate = self
        linkTextView.delegate = self

        avatarImageView.addSubview(changePhotoLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePhotoTapped))
        avatarImageView.addGestureRecognizer(tapGesture)

        [
            avatarImageView,
            nameTitleLabel,
            nameTextView,
            descriptionTitleLabel,
            descriptionTextView,
            linkTitleLabel,
            linkTextView,
            loader
        ].forEach {
            view.addSubview($0)
        }
    }

    private func setupLayout() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(22)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }

        changePhotoLabel.snp.makeConstraints { make in
            make.center.equalTo(avatarImageView)
        }

        nameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        nameTextView.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextView.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        linkTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        linkTextView.snp.makeConstraints { make in
            make.top.equalTo(linkTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func fillInitialValues() {
        nameTextView.text = presenter.name
        descriptionTextView.text = presenter.description
        linkTextView.text = presenter.website
        avatarImageView.kf.setImage(
            with: URL(string: presenter.avatar),
            placeholder: UIImage(named: "avatar_placeholder")
        )
    }

    private static func makeTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.segmentActive
        label.text = text
        return label
    }

    private static func makeTextView() -> UITextView {
        let textView = ClearableTextView()
        textView.font = UIFont.bodyRegular
        textView.backgroundColor = UIColor.segmentInactive
        textView.layer.cornerRadius = 16
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 42)
        return textView
    }

    // MARK: - Actions

    @objc private func saveAndClose() {
        presenter.saveProfileOnExit()
    }

    @objc private func changePhotoTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("Profile.edit.photo", comment: ""),
            message: NSLocalizedString("Profile.edit.photo.message", comment: ""),
            preferredStyle: .alert
        )

        alert.addTextField {
            $0.placeholder = "https://example.com/avatar.png"
        }

        alert.addAction(UIAlertAction(title: NSLocalizedString("General.cancel", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("General.ok", comment: ""), style: .default, handler: { [weak self] _ in
            guard let self,
                  let text = alert.textFields?.first?.text,
                  let url = URL(string: text) else { return }

            presenter.updateAvatar(text)
            avatarImageView.kf.setImage(with: url)
        }))

        present(alert, animated: true)
    }
}

// MARK: - EditProfileViewProtocol

extension EditProfileViewController: EditProfileViewProtocol {
    func showLoading() {
        loader.startAnimating()
    }

    func hideLoading() {
        loader.stopAnimating()
    }

    func close() {
        dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case nameTextView:
            presenter.updateName(textView.text)
        case descriptionTextView:
            presenter.updateDescription(textView.text)
        case linkTextView:
            presenter.updateWebsite(textView.text)
        default:
            break
        }
    }
}
