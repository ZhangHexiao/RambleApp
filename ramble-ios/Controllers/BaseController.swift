//
//  BaseController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-18.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

public class BaseController: UIViewController {
    
    override public func viewDidLoad() {
//        self.navigationController?.navigationBar.barTintColor = UIColor.init()
        
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    public func blockGuest() {
        let controller = ConnectionController.instance
        controller.isBlocker = true
        let navigator = RMBNavigationController(rootViewController: controller)
        present(navigator, animated: true)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Errors and loading
    func showLoading() {
        SVProgressHUD.show()
    }
    
    func showLoading(status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    func stopLoading() {
        SVProgressHUD.dismiss()
    }
    
    func stopLoading(_ completion: (() -> Void)?) {
        SVProgressHUD.dismiss {
            completion?()
        }
    }
    
    func showError(err: String) {
//        SVProgressHUD.showError(withStatus: err)
       let alert = UIAlertController(title: "Sorry...", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ action in
            alert.dismiss(animated: true)
        }
           ))
       self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccess(success: String) {
        SVProgressHUD.showSuccess(withStatus: success)
    }
}
