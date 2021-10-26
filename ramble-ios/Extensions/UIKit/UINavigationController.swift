//
//  UINavigationController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-10.
//  Copyright © 2018 Ramble Technologies  Inc. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func setBack() {
        //title = ""
        navigationItem.backBarButtonItem?.title = ""
        navigationBar.backItem?.title = ""

        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_back")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_back")
    }
}
