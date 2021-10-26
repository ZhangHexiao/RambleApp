//
//  UIStoryboard.swift
//  Project
//
//  Created by Benjamin Bourasseau on 2017-05-05.
//  Copyright © 2017 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    func instantiateViewController(with navigation: Navigation) -> UIViewController {
        return self.instantiateViewController(withIdentifier: navigation.identifier)
    }
    
    func viewController(for navigation: Navigation) -> UIViewController {
        return self.instantiateViewController(withIdentifier: navigation.identifier)
    }
}
