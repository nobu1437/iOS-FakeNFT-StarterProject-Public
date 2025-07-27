//
//  EditProfilePresenterProtocol.swift
//  FakeNFT
//
//  Created by mpplokhov on 24.07.2025.
//

protocol EditProfilePresenterProtocol: AnyObject {
    var name: String { get }
    var description: String { get }
    var website: String { get }
    var avatar: String { get }

    func updateName(_ name: String)
    func updateDescription(_ description: String)
    func updateWebsite(_ website: String)
    func updateAvatar(_ url: String)
    func saveProfileOnExit()
}
