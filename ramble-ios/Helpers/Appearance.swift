//
//  Appearance.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-18.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import Foundation

import SVProgressHUD
import IQKeyboardManagerSwift
//import UIColor_Hex_Swift

struct Appearance {
    
    static func config() {
        setupNavigationBar()
        setupToolTips()
        setupSVProgressHUD()
        setupKeyboard()
    }
    
    static func setupNavigationBar() {
        
//        get rid of the warning by chage the warning in the info.plist
//        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance(whenContainedInInstancesOf: [RMBNavigationController.self]).barStyle = .default
        UINavigationBar.appearance(whenContainedInInstancesOf: [RMBNavigationController.self]).barTintColor = UIColor.AppColors.navbarBackground
        UINavigationBar.appearance(whenContainedInInstancesOf: [RMBNavigationController.self]).tintColor = UIColor.lightGray
        
        UINavigationBar.appearance(whenContainedInInstancesOf: [RMBNavigationController.self]).titleTextAttributes = [
            NSAttributedString.Key.font: Fonts.Futura.medium.size(18),
            NSAttributedString.Key.foregroundColor: UIColor.white]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [RMBNavigationController.self]).setTitleTextAttributes([
            NSAttributedString.Key.font: Fonts.Futura.medium.size(16),
            NSAttributedString.Key.foregroundColor: UIColor.white],
                                                            for: .normal )
    }
    
    private static func setupSVProgressHUD() {
        SVProgressHUD.setMaximumDismissTimeInterval(TimeInterval(integerLiteral: 2))
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    private static func setupToolTips() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = Fonts.Futura.medium.size(14)
        preferences.drawing.arrowPosition = .bottom
    
        preferences.drawing.foregroundColor = UIColor.darkGray
        preferences.drawing.backgroundColor = .white
        preferences.drawing.textAlignment = .left

        EasyTipView.globalPreferences = preferences
    }
    
    private static func setupKeyboard() {
        //set IQKeyboardManager FALSE
        //To avoid the layout error of chatViewx
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }
}

extension UIColor {
    struct AppColors {
        
        static let darkGray = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1) //2A2A2A
        static let gray = UIColor(red: 82/255, green: 85/255, blue: 87/255, alpha: 1) //525557
        static let cityButton = UIColor(red: 236/255, green: 235/255, blue: 229/255, alpha: 1) //525557
        static let catogoryButton = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1) //525557
        static let placeHolderGray = UIColor(red: 82/255, green: 85/255, blue: 87/255, alpha: 1) //525557
        static let textGray = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
        static let unselectedTextGray = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 0.5) //#F7F7F8
        static let searchTextHolderGray = UIColor(red: 0/255, green: 0/255, blue: 0.0980392/255, alpha: 0.45) 
        static let background = UIColor(red: 13/255, green: 13/255, blue: 13/255, alpha: 1) //0D0D0D
        static let navbarBackground = UIColor(red: 2/255, green: 2/255, blue: 2/255, alpha: 1)  
        static let navBar = background.withAlphaComponent(0.5)
        
        static let red = UIColor(red: 230/255, green: 73/255, blue: 52/255, alpha: 1) //#E64934
        
        static let cardBackground = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1) //#181818
        
        static let bgPrimaryButton = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
        
        static let shareItem = UIColor(red: 136/255, green: 138/255, blue: 139/255, alpha: 0.5) //3A3A3A

        //#f7f7f8
        static let bgConnectionCreateButton = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        
        //#292A2A
        static let bgConnectionLoginButton = UIColor(red: 41/255, green: 41/255, blue: 42/255, alpha: 1)
        
        static let bgDisabledButton = bgConnectionLoginButton
        static let bgRedButton = red
        
        //#515151
        static let borderPrimaryButton = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1)
        
        //#39579A
        static let facebookBlue = UIColor(red: 57/255, green: 87/255, blue: 154/255, alpha: 1)
        
        //#39579A
        static let green = UIColor(red: 60/255, green: 214/255, blue: 118/255, alpha: 1) // 3CD676
        
        //#FF677F
        static let cancelled =  UIColor(red: 255/255, green: 103/255, blue: 127/255, alpha: 1)
        
        //#607D8B
        static let blocked =  UIColor(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
        
        //Chat view UI color Code
        static let textColrSender =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        static let textColrReceiver =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        static let backgroundSender =  UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        static let backgroundReceiver =  UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        static let collectionBackground =  UIColor(red: 13/255, green: 13/255, blue: 13/255, alpha: 1)
        static let selecSeg = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1) //#E64934
        static let unSelecSeg = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
        //gradient button color
        static let buttonLeft = UIColor(red: 43/255, green: 178/255, blue: 130/255, alpha: 1) //#E64934
        static let buttonRight = UIColor(red: 45/255, green: 115/255, blue: 234/255, alpha: 1)
        static let buttonLeftEmptyCell = UIColor(red: 235/255, green: 130/255, blue: 184/255, alpha: 1)
        static let buttonRightEmptyCell = UIColor(red: 171/255, green: 130/255, blue: 255/255, alpha: 1)
        //======================
        struct Band {
            static let green1 = UIColor(red: 60/255, green: 214/255, blue: 118/255, alpha: 1) // 3CD676
            static let green2 = UIColor(red: 111/255, green: 237/255, blue: 174/255, alpha: 1) // 6FEDAE
            
            static let gold1 = UIColor(red: 173/255, green: 166/255, blue: 74/255, alpha: 1) // ADA64A
            static let gold2 = UIColor(red: 173/255, green: 166/255, blue: 74/255, alpha: 1) // ADA64A
            
            static let platinum1 = UIColor(red: 101/255, green: 105/255, blue: 107/255, alpha: 1) // 65696B
            static let platinum2 = UIColor(red: 152/255, green: 154/255, blue: 157/255, alpha: 1) // 989A9D
            
            static let black1 = UIColor(red: 25/255, green: 24/255, blue: 24/255, alpha: 1) // 191818
            static let black2 = UIColor(red: 69/255, green: 68/255, blue: 68/255, alpha: 1) // 454444
        }
    }
}
