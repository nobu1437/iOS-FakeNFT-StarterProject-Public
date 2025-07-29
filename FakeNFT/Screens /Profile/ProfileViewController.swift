//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//
import UIKit
import SnapKit
import SafariServices

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private let presenter: ProfilePresenterProtocol
    private var lastLoadedModel: ProfileModel?

    // MARK: - UI Elements

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = UIColor.segmentActive
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.caption2
        label.textColor = UIColor.segmentActive
        return label
    }()

    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor.textBlue
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.insetsContentViewsToSafeArea = false
        tableView.layoutMargins = .zero
        return tableView
    }()

    private let progressHud: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: .medium)
        progress.hidesWhenStopped = true
        progress.color = UIColor.segmentActive
        return progress
    }()

    // MARK: - Init

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        setupNavigationBar()
        setupProgressHud()
        setupUI()
        
        presenter.setup()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editProfile)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor.segmentActive
        navigationItem.backButtonTitle = ""
    }

    private func setupProgressHud() {
        view.addSubview(progressHud)
        progressHud.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupUI() {
        [
            avatarImageView,
            nameLabel,
            descriptionLabel,
            linkLabel,
            tableView
        ].forEach {
            view.addSubview($0)
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(70)
        }

        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView.snp.centerY)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(linkLabel.snp.bottom).offset(40)
            make.leading.trailing.bottom.equalToSuperview()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLink))
        linkLabel.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions

    @objc
    private func editProfile() {
        guard let profileModel = lastLoadedModel else { return }
        let editVC = presenter.getEditProfileVC(for: profileModel)
        editVC.delegate = self
        let nav = UINavigationController(rootViewController: editVC)
        present(nav, animated: true)
    }

    @objc
    private func openLink() {
        guard let urlString = linkLabel.text,
              let url = URL(string: urlString)
        else { return }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = [
            NSLocalizedString("Profile.nft.purchased", comment: ""),
            NSLocalizedString("Profile.nft.favorite", comment: ""),
            NSLocalizedString("Profile.developer", comment: "")
        ]
        let counts = [
            "(\(lastLoadedModel?.nfts.count ?? 0))",
            "(\(lastLoadedModel?.likes.count ?? 0))",
            ""
        ]
        
        let cell = UITableViewCell()
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.textLabel?.font = UIFont.bodyBold
        cell.textLabel?.textColor = UIColor.segmentActive
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(titles[indexPath.row]) \(counts[indexPath.row])"
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        arrowImageView.tintColor = UIColor.segmentActive
        cell.accessoryView = arrowImageView
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let profileModel = lastLoadedModel else { return }
            let myNFTVC = presenter.getMyNFTProfileVC(for: profileModel)
            navigationController?.pushViewController(myNFTVC, animated: true)
        case 1:
            guard let profileModel = lastLoadedModel else { return }
            let favouritesVC = presenter.getFavouritesNFTVC(for: profileModel)
            navigationController?.pushViewController(favouritesVC, animated: true)
        default:
            break
        }
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func update(with model: ProfileModel) {
        lastLoadedModel = model
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        linkLabel.text = model.website?.absoluteString
        avatarImageView.kf.setImage(
            with: model.avatar,
            placeholder: UIImage(named: "avatar_placeholder")
        )

        tableView.reloadData()
    }

    func showProgressHud() {
        progressHud.startAnimating()
    }

    func hideProgressHud() {
        progressHud.stopAnimating()
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func didUpdateProfile(_ updatedModel: ProfileModel) {
        update(with: updatedModel)
    }
}
