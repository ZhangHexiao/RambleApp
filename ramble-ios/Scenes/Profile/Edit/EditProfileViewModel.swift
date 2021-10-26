//
//  EditProfileViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-18.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

enum ProfileViewType {
    case setup, edit
}

protocol EditProfileViewModelDelegate: class {
    func didLoadCoverImage()
    func didLoadProfileImage()
    func didSave()
    func didFail(error: String)
}

class EditProfileViewModel {
    
    var viewType: ProfileViewType = .setup
    
    var name: String?
    var lastName: String?
    var coverImage: UIImage?
    var profileImage: UIImage?
    
    weak var delegate: EditProfileViewModelDelegate?
    
    var title: String {
        switch viewType {
        case .setup: return "Account Setup".localized
        case .edit: return "Edit My Profile".localized
        }
    }
    
    func initData(user: User?) {
        name = user?.name
        lastName = user?.lastName
        
        switch viewType {
        case .setup:
            UserManager().getFacebookImage { [weak self] (image) in
                self?.profileImage = image
                self?.delegate?.didLoadProfileImage()
            }
        case .edit:
            ImageHelper.loadImage(data: user?.profileImage) { [weak self] image in
                self?.profileImage = image
                self?.delegate?.didLoadProfileImage()
            }
            ImageHelper.loadImage(data: user?.coverImage) { [weak self] image in
                self?.coverImage = image
                self?.delegate?.didLoadCoverImage()
            }
        }
    }
    
    func save() {
        
        User.current()?.name = name
        User.current()?.lastName = lastName
        
        UserManager().save { [weak self] (error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
            } else {
                self?.delegate?.didSave()
            }
        }
    }
    
    func validate(text: String) -> Bool {
        if let error = Validator.isValid(username: text) {
            delegate?.didFail(error: error)
            return true
        }
        return false
    }
    
    func addImagesToUser() {
        UserManager().updateProfile(image: profileImage)
        UserManager().updateCover(image: coverImage)
    }
}
