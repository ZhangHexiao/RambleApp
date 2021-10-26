//
//  SettingsController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNavbar()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "Settings".localized
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: SettingsCell.self)
    }
    
    private func logout() {
        AuthManager.logout {
            replaceRootViewController(to: RMBNavigationController(rootViewController: ConnectionController.instance), animated: true, completion: nil)
        }
    }
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsMenuType.kNumberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: SettingsCell.self, indexPath: indexPath)
        cell.configure(with: SettingsMenuType(rawValue: indexPath.row) ?? SettingsMenuType.none)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsCell.kHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = SettingsMenuType(rawValue: indexPath.row) else { return }
        
        switch menuType {
        case .editProfile:
            let editProfile = EditProfileController.instance
            editProfile.viewModel.viewType = .edit
            navigationController?.pushViewController(editProfile, animated: true)
        
        case .changePassword:
            
            if User.current()?.authType == UserAuthType.facebook.rawValue {
                showError(err: RMBError.cantChangeFacebookPassword.localizedDescription)
                return
            }

            navigationController?.pushViewController(ChangePasswordController.instance, animated: true)
            
        case .terms:
            let webView = WebViewController.instance
            webView.viewModel.type = .termsAndConditions
            navigationController?.pushViewController(webView, animated: true)
        
        case .privacy:
            let webView = WebViewController.instance
            webView.viewModel.type = .privacyPolicy
            navigationController?.pushViewController(webView, animated: true)
        
        case .contactUs:
            let contact = ContactController.instance
            contact.viewModel.inject(type: .contactUs, event: nil)
            navigationController?.pushViewController(contact, animated: true)
        
        case .logout:
            RMBAlert.confirmLogout.show(on: self) { [weak self] _ in
                self?.logout()
            }
        case .none: break
        }
    }
}

extension SettingsController {
    static var instance: SettingsController {
        guard let vc = Storyboard.Settings.viewController(for: .settings) as? SettingsController else {
            assertionFailure("Something wrong while instantiating SettingsController")
            return SettingsController()
        }
        return vc
    }
}
