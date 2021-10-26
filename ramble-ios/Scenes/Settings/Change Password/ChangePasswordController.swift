//
//  ChangePasswordController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ChangePasswordController: BaseController {
    
    @IBOutlet weak var setPassLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: RMBTextField!
    @IBOutlet weak var newPasswordTextField: RMBTextField!
    @IBOutlet weak var newPasswordAgainTextField: RMBTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNavbar()
        self.loadLayout()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = SettingsMenuType.changePassword.localized()
        setPassLabel.text = "setPassMessage".localized
        let itemCancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = itemCancel
        
        let itemSave = UIBarButtonItem(title: "Save".localized, style: .plain, target: self, action: #selector(actionSave))
        navigationItem.rightBarButtonItem = itemSave
    }
    
    // MARK: Layout
    
    func loadLayout() {
        oldPasswordTextField.placeholder = "Old Password".localized
        newPasswordTextField.placeholder = "New Password".localized
        newPasswordAgainTextField.placeholder = "New password again".localized
    }
    
    // MARK: - Actions
    @objc private func actionCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func actionSave() {
        
        guard let email = User.current()?.email,
            let oldPassword = oldPasswordTextField.text,
            let newPassword = newPasswordTextField.text,
            let newPasswordAgain = newPasswordAgainTextField.text else {
                showError(err: RMBError.emptyFields.localizedDescription)
                return
        }
        
        if prepareToSave(email: email, oldPassword: oldPassword, newPassword: newPassword, newPasswordAgain: newPasswordAgain) {
            showLoading()
            change(email: email, oldPassword: oldPassword, newPassword: newPassword)
        }
    }
    
    func prepareToSave(email: String, oldPassword: String, newPassword: String, newPasswordAgain: String) -> Bool {
        
        if Validator.isEmpty(text: oldPassword) {
            showError(err: RMBError.oldPasswordEmpty.localizedDescription)
            oldPasswordTextField.becomeFirstResponder()
            return false
        }
        
        if newPassword != newPasswordAgain {
            showError(err: RMBError.newPasswordsDontMatch.localizedDescription)
            newPasswordAgainTextField.becomeFirstResponder()
            return false
        }
        
        if Validator.isEmpty(text: newPassword) {
            showError(err: RMBError.newPasswordEmpty.localizedDescription)
            newPasswordTextField.becomeFirstResponder()
            return false
        }
        
        if Validator.isEmpty(text: newPasswordAgain) {
            showError(err: RMBError.newPasswordEmpty.localizedDescription)
            newPasswordAgainTextField.becomeFirstResponder()
            return false
        }
        
        if let err = Validator.isValid(password: newPasswordAgain) {
            showError(err: err)
            newPasswordAgainTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func change(email: String, oldPassword: String, newPassword: String) {
        AuthManager().changePassword(email: email,
                                     oldPassword: oldPassword,
                                     newPassword: newPassword) { [weak self] (error) in
                                        self?.finishLoading(error: error)
        }
    }
    
    func finishLoading(error: String?) {
        stopLoading { [weak self] in
            if let err = error {
                self?.showError(err: err)
            } else {
                self?.showSuccess(success: "Password successfully changed".localized)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension ChangePasswordController {
    static var instance: ChangePasswordController {
        guard let vc = Storyboard.Profile.viewController(for: .changePassword) as? ChangePasswordController else {
            assertionFailure("Something wrong while instantiating ChangePasswordController")
            return ChangePasswordController()
        }
        return vc
    }
}
