//
//  WebViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-13.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

enum WebViewType: String {
    case termsAndConditions
    case privacyPolicy
}

class WebViewModel {
    typealias WebViewHandler = ((_ url: URL?, _ error: String?) -> Void)?

    var type: WebViewType = .privacyPolicy
    
    func load(_ completion: WebViewHandler) {
        
        PFConfig.getInBackground { [weak self] (config, error) in
            let urlString: String? = config?[self?.type.rawValue ?? ""] as? String
            completion?(URL(string: urlString ?? ""), error?.localizedDescription)
        }
    }
}
