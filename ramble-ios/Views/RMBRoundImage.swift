//
//  RMBRoundImage.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-30.
//  Created by HexiaoZhang Ramble Technologies Inc. on 2020-08-08.
//

import UIKit

class RMBRoundImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
        masksToBounds = true
    }
}
