//
//  RMBDistanceHelper.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-09.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import CoreLocation

class RMBDistanceHelper {
    
    let montrealCoordinates = (lat: 45.50884, lng: -73.58781)
    
    func distanceInMeters(from coordinates1: (lat: Double, lng: Double), to coordinates2: (lat: Double, lng: Double)) -> Double {
        let location1 = CLLocation(latitude: coordinates1.lat, longitude: coordinates1.lng)
        let location2 = CLLocation(latitude: coordinates2.lat, longitude: coordinates2.lng)
        
        return location1.distance(from: location2)
    }
    
    func distanceInMetersToUser(from coordinates1: (lat: Double, lng: Double)) -> Double {
        var location2 = montrealCoordinates
        if let userLocation = User.current()?.location {
            location2 = (lat: userLocation.latitude, lng: userLocation.longitude)
        }
        return distanceInMeters(from: coordinates1, to: location2)
    }
}
