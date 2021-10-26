//
//  Alert.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-22.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

enum RMBAlert {
    case confirmLogout
    case confirmCancelEvent
    case confirmDeleteEvent
    case blockedEvent
    case settingsLocation
    case forgetPassword
}

extension RMBAlert {
    
    public func show(on vc: UIViewController, _ action: @escaping (_ text: String? ) -> Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        switch self {
        case .confirmLogout:
            alert.title = "Are you sure?".localized
            alert.message = "You will be disconnected from your account".localized
            okCancelActions(alert, actionTitle: "Continue".localized, action)
        
        case .confirmCancelEvent:
            alert.title = "Do you want to cancel this event?".localized
            okCancelActions(alert, action)
        
        case .confirmDeleteEvent:
            alert.title = "Do you want to delete this event?".localized
            okCancelActions(alert, action)
        
        case .blockedEvent:
            alert.title = "Blocked event".localized
            alert.message = "This event has been blocked due to inappropriate content. No one can see it. To resolve this issue, contact the admin team".localized
            blockedEventActions(alert, action)
            
        case .forgetPassword:
            alert.title = "Fill your email address".localized
            forgetPassword(alert, action)
            
        case .settingsLocation:
            alert.message =  "You need to activate location service to use this feature. Please turn on GPS mode in location settings".localized
            okCancelActions(alert, actionTitle: "Settings".localized, action)
            
        }
        
        show(alert: alert, on: vc)
    }
    
    private func show(alert: UIAlertController, on vc: UIViewController) {
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
}

extension RMBAlert { 
    
    private func okCancelActions(_ alert: UIAlertController, actionTitle: String? = nil, _ action: @escaping (_ text: String?) -> Void) {
        
        let action = UIAlertAction(title: actionTitle ?? "Ok".localized, style: .default) { (_) in action(nil) }
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
    }
    
    private func blockedEventActions(_ alert: UIAlertController, _ action: @escaping (_ text: String?) -> Void) {
        
        alert.addAction(UIAlertAction(title: "Maybe later".localized, style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Contact admin".localized, style: .default, handler: { (_) in action(nil) }))
    }
    
    private func forgetPassword(_ alert: UIAlertController, _ action: @escaping (_ text: String?) -> Void) {
        
        alert.addTextField(configurationHandler: nil)
        
        let sendAction = UIAlertAction(title: "Send".localized, style: .default, handler: { _ in
            action(alert.textFields?.first?.text)
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
    }
}
