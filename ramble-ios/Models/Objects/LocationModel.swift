//
//  LocationModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-13.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

struct LocationModel {
    
    var id: String
    var lat: Double?
    var lng: Double?
    var location: String?
    var city:String?
    
    init(id: String) {
        self.id = id
    }
    
    init(id: String, lat: Double?, lng: Double?, location: String?) {
        self.id = id
        self.lat = lat
        self.lng = lng
        self.location = location
    }
    
    func getCity()-> String {
        
        if self.location != nil {
            var fullAdress: [String]
            fullAdress = self.location!.components(separatedBy: ",")
            let city = fullAdress[1].trimmingCharacters(in: CharacterSet.whitespaces)
            return city
        }
        else
        {return "Canada"}
    }
}
