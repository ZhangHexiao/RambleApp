//
//  UserManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-06.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class UserManager {
    
    func save(completion: @escaping (_ error: String?) -> Void) {
        User.current()?.saveInBackground(block: { (_, error) in
            if error != nil {
                completion(error!.localizedDescription)
            } else {
                completion(nil)
            }
        })
    }
    
    func updateProfile(image: UIImage?) {
        
        guard let image = image else {
            User.current()?.profileImage = nil
            GRNNotif.updatedProfileImage.postNotif(nil)
            return
        }
        
        guard let imageData = ImageHelper.imageToData(image: image, width: 300, name: "profile", withAlpha: true) else {
            return
        }

        User.current()?.profileImage = imageData
        User.current()?.cachedProfileImage = image
        
        GRNNotif.updatedProfileImage.postNotif(image)
    }
    
    func updateCover(image: UIImage?) {
        guard let image = image else {
            User.current()?.coverImage = nil
            return
        }
        guard let imageData = ImageHelper.imageToData(image: image, name: "cover") else {
            return
        }
        
        User.current()?.coverImage = imageData
    }
    
    func getCurrentLocation(_ completion:((_ coordinates: (Double, Double)?) -> Void)? = nil) {
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let err = error {
                print("geoPointForCurrentLocation error \(err.localizedDescription)")
            } else {
                guard let geoPoint = geoPoint else {
                    completion?(nil)
                    return
                }
                
                User.current()?.location = geoPoint
                completion?((geoPoint.latitude, geoPoint.longitude))
                self.save(completion: { (error) in
                    guard error == nil else {
                        print("geoPointForCurrentLocation error \(error!)")
                        return
                    }
                })
            }
        }
    }
}

extension UserManager {
    // Check if all user details has been filled
    // Return false if any detail is missing
    static func hasUserCompletedProfile() -> Bool {
        if let user = User.current() {
            if user.name == nil ||
                user.lastName == nil {
                return false
            } else {
                return true
            }
        }
        return true
    }
}

extension UserManager {
    func getFacebookImage(facebookId: String? = nil, done: @escaping (_ img: UIImage?) -> Void) {
        
        let facebookId = facebookId ?? User.current()?.facebookId
        
        if let fId = facebookId {
            let imgString = "https://graph.facebook.com/\(fId)/picture?type=large&return_ssl_resources=1"
            guard let facebookImageUrl = imgString.toUrl() else {
                done(#imageLiteral(resourceName: "ic_user"))
                return
            }
            
            facebookImageUrl.downloadData({ (data) in
                if let data = data {
                    if let img = UIImage(data: data) {
                        done(img)
                    } else {
                        done(nil)
                    }
                } else {
                    done(nil)
                }
            })
            
        } else {
            done(nil)
        }
    }
    
}
