//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//
import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private let presenter: ProfilePresenterProtocol

    // MARK: - UI Elements

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .avatar)
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix"
        label.font = UIFont.headline3
        label.textColor = UIColor.segmentActive
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.caption2
        label.textColor = UIColor.segmentActive
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        return label
    }()

    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor.textBlue
        label.text = "Joaquin Phoenix.com"
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
        return tableView
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
        setupUI()
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
    }

    @objc
    private func openLink() {
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = [
            NSLocalizedString("Profile.nft.purchased", comment: ""),
            NSLocalizedString("Profile.nft.favorite", comment: ""),
            NSLocalizedString("Profile.developer", comment: "")
        ]
        let counts = [
            "(112)",
            "(11)",
            ""
        ]
        
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.bodyBold
        cell.textLabel?.textColor = UIColor.segmentActive
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(titles[indexPath.row]) \(counts[indexPath.row])"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
}
