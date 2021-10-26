//
//  UIImageView.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-16.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func generateQRCode(code: String) {
        
        let data = code.data(using: .isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        if let qrcodeImage = filter?.outputImage {
            
            let scaleX = frame.size.width / qrcodeImage.extent.size.width
            let scaleY = frame.size.height / qrcodeImage.extent.size.height
            
            let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            image = UIImage(ciImage: transformedImage)
        }
    }
}
