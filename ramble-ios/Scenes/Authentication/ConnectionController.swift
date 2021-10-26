//
//  ConnectionController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class ConnectionController: BaseController {
    
    @IBOutlet weak var iHaveAccBtn: RMBButton!
    @IBOutlet weak var createAccBtn: RMBButton!
    @IBOutlet weak var continueAsGuestButton: UIButton!
    
    var isBlocker: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        continueAsGuestButton.setTitle("Continue as guest".localized, for: .normal)
        createAccBtn.setTitle("CREATE A NEW ACCOUNT".localized.uppercased(), for: .normal)
        iHaveAccBtn.setTitle("I HAVE AN ACCOUNT".localized.uppercased(), for: .normal)
        navigationController?.setNavigationBarHidden(true, animated: false)
    
        continueAsGuestButton.addTarget(self, action: #selector(startAsGuest), for: .touchUpInside)
    }
    
    @objc private func startAsGuest() {
        if isBlocker {
            dismiss(animated: true)
        } else {
            replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    @IBAction func actionSignup() {
        let signup = SignupController.instance
        signup.fromBlock = isBlocker
        signup.hidesBottomBarWhenPushed = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(signup, animated: true)
        
    }
    
    @IBAction func actionLogin() {
        let login = LoginController.instance
        login.fromBlock = isBlocker
        login.hidesBottomBarWhenPushed = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(login, animated: true)
    }
}

extension ConnectionController {
    static var instance: ConnectionController {
        guard let vc = Storyboard.Authentication.viewController(for: .connection) as? ConnectionController else {
            assertionFailure("Something wrong while instantiating ConnectionController")
            return ConnectionController()
        }
        return vc
    }
}
