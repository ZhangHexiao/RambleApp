//
//  SignupController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SignupController: BaseController {
    
    @IBOutlet weak var emailTextField: RMBTextField!
    @IBOutlet weak var passwordTextField: RMBTextField!
    
    @IBOutlet weak var termsButton: RMBButton!
    
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
        navigationItem.title = "Create a New Account".localized
    }
        
    // MARK: Layout
    
    func loadLayout() {
        emailTextField.placeholder = "Email address".localized
        passwordTextField.placeholder = "Password".localized
        termsButton.setTitle("by creating an account, you agree our terms and conditions".localized, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func actionFacebook() {
        viewModel.actionFacebook()
    }
    
    @IBAction func actionSignup() {
        if viewModel.validate(email: emailTextField.text!) {
            emailTextField.becomeFirstResponder()
            return
        }
        if viewModel.validate(password: passwordTextField.text!) {
            passwordTextField.becomeFirstResponder()
            return
        }
        
        viewModel.actionSignup(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func actionTerms() {
        let webView = WebViewController.instance
        webView.viewModel.type = .termsAndConditions
        navigationController?.pushViewController(webView, animated: true)
    }
    
}

extension SignupController: AuthViewModelDelegate {
    func didFail(error: String) {
        showError(err: error)
    }
    
    func didSuccess(msg: String) {
        showSuccess(success: msg)
    }
    
    func didConnect(type: AuthTypeRoute) {
        switch type {
        case .accountSetup, .main:
            let edit = EditProfileController.instance
            edit.fromBlock = fromBlock
            navigationController?.pushViewController(edit, animated: true)
        }
    }
}

extension SignupController {
    static var instance: SignupController {
        guard let vc = Storyboard.Authentication.viewController(for: .signup) as? SignupController else {
            assertionFailure("Something wrong while instantiating SignupController")
            return SignupController()
        }
        return vc
    }
}
