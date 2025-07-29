//
//  FavouritesNFTViewController.swift
//  FakeNFT
//
//  Created by mpplokhov on 29.07.2025.
//

import UIKit

final class FavouritesNFTViewController: UIViewController {

    private let presenter: FavouritesNFTPresenterProtocol
    private var nftList: [NFTModel] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)

        let itemWidth = (UIScreen.main.bounds.width - 16 * 2 - 8) / 2 // padding 16 * 2 + 8 spacing
        layout.itemSize = CGSize(width: itemWidth, height: 80)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.favouritesNFT.emptyMessage", comment: "")
        label.textColor = UIColor.segmentActive
        label.font = UIFont.bodyBold
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let progressHud: UIActivityIndicatorView = {
        let hud = UIActivityIndicatorView(style: .medium)
        hud.hidesWhenStopped = true
        hud.color = UIColor.segmentActive
        return hud
    }()

    init(presenter: FavouritesNFTPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Profile.favouritesNFT.title", comment: "")
        view.backgroundColor = UIColor.background
        navigationController?.navigationBar.tintColor = .black

        setupUI()
        presenter.loadNFTs()
    }

    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        view.addSubview(progressHud)

        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        emptyLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        progressHud.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

extension FavouritesNFTViewController: FavouritesNFTViewProtocol {
    func update(with nfts: [NFTModel]) {
        nftList = nfts
        collectionView.isHidden = nfts.isEmpty
        emptyLabel.isHidden = !nfts.isEmpty
        collectionView.reloadData()
    }

    func showProgressHud() {
        progressHud.startAnimating()
    }

    func hideProgressHud() {
        progressHud.stopAnimating()
    }
}

extension FavouritesNFTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: nftList[indexPath.item])
        return cell
    }
}

extension FavouritesNFTViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftList.count
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
        return 80
    }
}
