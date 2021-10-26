//
//  SplashController.swift
//  ramble-ios
//
//  Created by Benjamin Bourasseau on 2017-05-12.
//  Copyright © 2017 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class SplashController: BaseController {
    
    @IBOutlet weak var ai: UIActivityIndicatorView!

    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavItem()
    }

    // MARK: Navigation

    private func loadNavItem() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /// Perform initial data loading
    private func initData() {
//        get rid of warning by set the value in the Info.plist
//        UIApplication.shared.isStatusBarHidden = false
        ai.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            let when = DispatchTime.now() + DispatchTimeInterval.seconds(1)
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                // Do your loading stuff here and throw an error if needed
                self.ai.stopAnimating()
                
                if User.current() == nil {
                    self.unauthenticatedFlow()
                } else {
                    UserManager().getCurrentLocation()
                    self.authenticatedFlow()
                }
            })
        }
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    private func unauthenticatedFlow() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Navigation.splash.to(.authentication), sender: self)
        }
    }
    
    private func authenticatedFlow() {
        DispatchQueue.main.async {
            if UserManager.hasUserCompletedProfile() {
                replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
            } else {
                
                replaceRootViewController(to: RMBNavigationController(rootViewController: EditProfileController.instance), animated: true, completion: nil)
            }
        }
    }
}

extension SplashController {
    public static var instance: SplashController {
        guard let vc = Storyboard.Main.viewController(for: .splash) as? SplashController else {
            assertionFailure("Something wrong while instantiating SplashController")
            return SplashController()
        }
        return vc
    }
}
