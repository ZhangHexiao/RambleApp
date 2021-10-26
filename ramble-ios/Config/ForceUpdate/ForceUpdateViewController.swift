//
//  ForceUpdateViewController.swift
//  GCReno-ios
//
//  Created by Omran on 2019-01-28.
//  Copyright © 2019 Omran. All rights reserved.
//

import Foundation
import UIKit

open class ForceUpdateViewController: UIViewController {
    
    open var environment: Environment!
    open var installationUrl: String!
    
    open var popupMessage: String = "updateApp".localized
    open var updateMessage: String = "Update".localized
    
    // MARK: Lifecycle
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUpdateAlert()
    }
    
    // MARK: Update alert
    
    private func showUpdateAlert() {
        let alert = UIAlertController(title: nil, message: popupMessage, preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: updateMessage, style: .cancel) { _ in
            guard let customAppURL = URL(string: self.installationUrl) else {
                print("GRNForceUpdate Error: Unable to create URL \(self.installationUrl ?? "No url")")
                return
            }
            UIApplication.shared.open(customAppURL, options: [:], completionHandler: { (_) in
                exit(0)
            })
        }
        alert.addAction(updateAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

