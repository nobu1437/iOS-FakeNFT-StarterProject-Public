//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

import SnapKit
import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private let presenter: ProfilePresenterProtocol

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
}
