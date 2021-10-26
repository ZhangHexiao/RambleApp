//
//  Route.swift
//  FLDR
//
//  Created by Benjamin Bourasseau on 20/01/2016.
//  Copyright © 2016 Benjamin. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let Main = UIStoryboard(name: "Main", bundle: nil)
    static let Authentication = UIStoryboard(name: "Authentication", bundle: nil)
    static let Profile = UIStoryboard(name: "Profile", bundle: nil)
    static let Notifications = UIStoryboard(name: "Notifications", bundle: nil)
    static let Home = UIStoryboard(name: "Home", bundle: nil)
    static let HomePage = UIStoryboard(name: "HomePage", bundle: nil)
    static let Map = UIStoryboard(name: "Map", bundle: nil)
    static let Settings = UIStoryboard(name: "Settings", bundle: nil)
    static let EventCreation = UIStoryboard(name: "EventCreation", bundle: nil)
    static let Searchevent = UIStoryboard(name: "Searchevent", bundle: nil)
    static let PromoterApp = UIStoryboard(name: "PromoterApp", bundle: nil)
}

public enum Navigation: String {
    
    // Authentication
    case authentication = "Authentication" // Storyboard
    case splash = "Splash"
    case connection  = "Connection"
    case signup  = "Signup"
    case login  = "Login"
    
    case editProfile  = "EditProfile"
    case profile = "Profile"
    case notifications  = "Notifications"
    
    case home = "Home"
    case homePage = "HomePage"
//    ========add search event tab==========
    case searchevent = "Searchevent"
//    ====================================
    case filter = "Filter"
    case tabbar = "Tabbar"
    case map = "Map"
    case getTickets = "GetTickets"
    case eventDetails = "EventDetails"
    case payment = "Payment"
    case addCreditCard = "AddCreditCard"
    case ticketsBought = "TicketsBought"
    case friendsList = "FriendsList"
    case eventsList = "EventsList"
    case interestedUsers = "InterestedUsers"
    case selectEvent = "SelectEvent"
    case band = "Band"
    case settings = "Settings"
    case contact = "Contact"
    case changePassword = "ChangePassword"
    case newEvent = "NewEvent"
    case categories = "Categories"
    case location = "Location"
    case selectDate = "SelectDate"
    case webView = "WebView"
    case selectCity = "SelectCity"
    case expCategory = "ExpCategory"
    case CalendarSelection = "CalendarSelection"
    /*! Return the view controller identifier */
    public var identifier: String {
        return "\(self.rawValue)Controller"
    }
    
    /*! Return the segue associated to the destination ex: LoginToSignup */
    public func to(_ to: Navigation) -> String {
        return "\(self.rawValue)To\(to.rawValue)"
    }
}

func replaceRootViewController(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
    let window = UIApplication.shared.keyWindow
    window?.rootViewController?.dismiss(animated: false, completion: nil)
    
    if animated {
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let oldState: Bool = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window!.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ -> Void in
            if completion != nil {
                completion!()
            }
        })
    } else {
        window!.rootViewController = viewController
    }
}
