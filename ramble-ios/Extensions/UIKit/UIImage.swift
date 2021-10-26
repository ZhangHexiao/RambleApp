//
//  UIImage.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-08-31.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// Resize to a specified width and keeping ratio
    func resizedToWidth(_ width: CGFloat) -> UIImage? {
        
        let oldWidth = self.size.width
        
        //dont resize if smaller
        if oldWidth <= width { return self }
        
        let scaleFactor =  width / oldWidth
        let newHeight = self.size.height * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // Create a circular image    
    func circularImage(width: CGFloat?) -> UIImage? {
        
        let newSize = width != nil ? CGSize(width: width!, height: width!) : self.size
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context?.setBlendMode(.copy)
        context?.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
                
        let circlePath = UIBezierPath(arcCenter: CGRect(origin: CGPoint.zero, size: size).center, radius: 12, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}

extension UIImage {
    
    func addBorder(width: CGFloat, color: UIColor) -> UIImage? {
        
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
