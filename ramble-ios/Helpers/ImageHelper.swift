//
//  ImageHelper.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-07.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import SDWebImage

class ImageHelper {
    
    class func loadImage(data: PFFileObject?, done: @escaping (_ img: UIImage?) -> Void) {
        guard let data = data else {
            done(nil)
            return
        }
        
        if let imageUrlString = data.url, let url = URL(string: imageUrlString ) {
            // is cached
            if let image = SDImageCache.shared().imageFromCache(forKey: imageUrlString) {
                done(image)
            } else {
                
                // Download and cached it
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .continueInBackground, progress: nil, completed: { (image, _, _, _) in
                    
                    guard let image = image else {
                        done(nil)
                        return
                    }
                    
                    SDImageCache.shared().store(image, forKey: imageUrlString, completion: nil)
                    done(image)
                })
            }
        } else {
            // Url is invalid, try to get the data from parse object
            data.getDataInBackground(block: { (data, err) in
                
                if err != nil {
                    done(nil)
                } else {
                    guard let data = data else {
                        done(nil)
                        return
                    }
                    guard let image = UIImage(data: data) else {
                        done(nil)
                        return
                    }
                    done(image)
                }
            })
        }
        
    }
    
    class func imageToData(image: UIImage?, width: CGFloat = 1125, name: String = "picture", withAlpha: Bool = false) -> PFFileObject? {
        
        guard let image = image else { return nil }

        var imageName = name
        
        let resizedImage = image.resizedToWidth(width) ?? image
        
        var data: Data?
        if withAlpha {
            data = resizedImage.pngData()
            imageName.append(".png")
        } else {
            data = resizedImage.jpegData(compressionQuality: 1)
            imageName.append(".jpg")
        }
        
        guard let imageData = data else { return nil }
        
        return PFFileObject(name: imageName, data: imageData)
    }
}
