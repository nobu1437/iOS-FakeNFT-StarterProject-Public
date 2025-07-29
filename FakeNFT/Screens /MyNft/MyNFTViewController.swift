//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by mpplokhov on 28.07.2025.
//

import UIKit

final class MyNFTViewController: UIViewController {

    // MARK: - Properties

    private let presenter: MyNFTPresenterProtocol
    private var nftList: [NFTModel] = []

    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.myNFT.emptyMessage", comment: "")
        label.textColor = UIColor.segmentActive
        label.font = UIFont.bodyBold
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var sortButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
    }()

    private let progressHud: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: .medium)
        progress.hidesWhenStopped = true
        progress.color = UIColor.segmentActive
        return progress
    }()

    // MARK: - Init

    init(presenter: MyNFTPresenterProtocol) {
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
        title = NSLocalizedString("Profile.myNFT.title", comment: "")
        navigationItem.rightBarButtonItem = sortButton
        navigationController?.navigationBar.tintColor = .black

        setupProgressHud()
        setupUI()
        presenter.loadNFTs()
    }

    // MARK: - Setup

    private func setupProgressHud() {
        view.addSubview(progressHud)
        progressHud.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc private func sortTapped() {
        presenter.sortNFTs()
    }
}

// MARK: - MyNFTViewProtocol

extension MyNFTViewController: MyNFTViewProtocol {
    
    func update(with nfts: [NFTModel]) {
        self.nftList = nfts
        tableView.isHidden = nfts.isEmpty
        emptyLabel.isHidden = !nfts.isEmpty
        tableView.reloadData()
    }
    
    func showProgressHud() {
        progressHud.startAnimating()
    }

    func hideProgressHud() {
        progressHud.stopAnimating()
    }
}

// MARK: - UITableViewDataSource & Delegate

extension MyNFTViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NFTTableViewCell.identifier,
            for: indexPath
        ) as? NFTTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: nftList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
