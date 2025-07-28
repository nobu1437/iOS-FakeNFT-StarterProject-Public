//
//  ProfileViewProtocol.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

protocol ProfileViewProtocol: AnyObject {
    func update(with model: ProfileModel)
    func showProgressHud()
    func hideProgressHud()
}
