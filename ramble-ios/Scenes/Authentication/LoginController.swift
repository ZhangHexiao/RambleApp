//
//  LoginController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class LoginController: BaseController {
    
    @IBOutlet weak var emailTextField: RMBTextField!
    @IBOutlet weak var passwordTextField: RMBTextField!
    
    @IBOutlet weak var forgotPassBtn: UIButton!
    let viewModel: AuthViewModel = AuthViewModel()
    
    var fromBlock: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNavbar()
        self.loadLayout()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setBack()
        navigationItem.title = "Log In".localized
    }
    
    // MARK: Layout
    
    func loadLayout() {
        emailTextField.placeholder = "Email address".localized
        passwordTextField.placeholder = "Password".localized
        forgotPassBtn.setTitle("Forgot your password?".localized, for: .normal)
        
        emailTextField.placeholderColor = UIColor.AppColors.placeHolderGray
        passwordTextField.placeholderColor = UIColor.AppColors.placeHolderGray
        
        emailTextField.textColor = UIColor.AppColors.textGray
        passwordTextField.textColor = UIColor.AppColors.textGray
    }
    
    // MARK: - Actions
    @IBAction func actionFacebook() {
        viewModel.actionFacebook()
    }
    
    @IBAction func actionLogin() {
                
        if viewModel.validate(email: emailTextField.text!) {
            emailTextField.becomeFirstResponder()
            return
        }
        if viewModel.validate(password: passwordTextField.text!) {
            passwordTextField.becomeFirstResponder()
            return
        }
        
        viewModel.actionLogin(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func actionForgotPassword() {
        
        RMBAlert.forgetPassword.show(on: self) { [weak self] (email) in
            if let email = email {
                self?.showLoading()
                self?.viewModel.forgotPassword(email: email)
            } else {
                self?.showError(err: RMBError.unknown.localizedDescription)
            }
        }
    }
}

// MARK: - AuthViewModelDelegate
extension LoginController: AuthViewModelDelegate {
    func didFail(error: String) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
    }
    
    func didSuccess(msg: String) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
    }
    
    func didConnect(type: AuthTypeRoute) {
        switch type {
        case .main:
            if fromBlock {
                dismiss(animated: true)
                GRNNotif.guestLoggedIn.postNotif(nil)
            } else {
                replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
            }
            
        case .accountSetup:
            let edit = EditProfileController.instance
            edit.fromBlock = fromBlock
            navigationController?.pushViewController(edit, animated: true)
        }
    }
}

extension LoginController {
    static var instance: LoginController {
        guard let vc = Storyboard.Authentication.viewController(for: .login) as? LoginController else {
            assertionFailure("Something wrong while instantiating LoginController")
            return LoginController()
        }
        return vc
    }
}
