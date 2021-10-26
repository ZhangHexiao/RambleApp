//
//  URL.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-07.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

public extension URL {
    
    /// If String is an url, you can perform a get data call
    func downloadData(_ done: @escaping (_ data: Data?) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            let data = try? Data(contentsOf: self)
            DispatchQueue.main.async {
                if let data = data {
                    done(data)
                } else {
                    done(nil)
                }
            }
        }
    }
}
