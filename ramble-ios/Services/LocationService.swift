//
//  GooglePlacesService.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import GooglePlaces
import MapboxGeocoder

protocol LocationServiceDelegate: class {
    func didUpdateSearchResult(data: [LocationModel])
    func didFail(error: String)
}

class LocationService: NSObject {
    
    var fetcher: GMSAutocompleteFetcher?
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        // CA = Canada
        filter.country = "CA"
        filter.type = .noFilter // user can search for an address or cinema for example
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        fetcher?.delegate = self
    }
    
    public func seach(_ text: String) {
        fetcher?.sourceTextHasChanged(text)
    }
    
    /// Google places GMSAutocompleteFetcher doesn't return latitude and longitude
    /// We fetch all data after user selecting a location
    public func getFullData(for location: LocationModel, _ completion:((_ location: LocationModel) -> Void)? = nil) {
        
        GMSPlacesClient.shared().lookUpPlaceID(location.id, callback: {(place, error) in
            if error != nil {
                completion?(location)
                return
            }
            
            var location: LocationModel = location
            
            location.lat = place?.coordinate.latitude
            location.lng = place?.coordinate.longitude
            completion?(location)
        })
    }
    
    public func getUserLocation(_ completion:((_ location: LocationModel?) -> Void)? = nil) {
        UserManager().getCurrentLocation { coordinates in
            guard let coordinates = coordinates else {
                completion?(nil)
                return
            }
            
            let option = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1))
            
            Geocoder.shared.geocode(option) { (placeMarks, attribution, errkr) in
                
                let placeMark = placeMarks?.first
                
                let city = placeMark?.postalAddress?.city ?? "Canada"
                
                var address = ""
                if let number = placeMark?.subThoroughfare, let street = placeMark?.thoroughfare {
                    address = "\(number) \(street)"
                } else if let street = placeMark?.addressDictionary?["street"] as? String {
                    address = street
                } else {
                    address = city
                }
                
                completion?(LocationModel(id: "", lat: coordinates.0, lng: coordinates.1, location: "\(address), \(city)"))
            }
            
        } // end of getCurrentLocation
    }
    
    public func getResetLocation(coordinateReset:(latitude:Double, longitude:Double)?, _ completion:((_ location: LocationModel?) -> Void)? = nil) {

        var coordinates = (latitude:45.50884, longitude:-73.58781)
        if coordinateReset != nil {
            coordinates = coordinateReset!
        }

        let option = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1))
        
        Geocoder.shared.geocode(option) { (placeMarks, attribution, errkr) in
            
            let placeMark = placeMarks?.first
            
            let city = placeMark?.postalAddress?.city ?? "Canada"
            
            var address = ""
            if let number = placeMark?.subThoroughfare, let street = placeMark?.thoroughfare {
                address = "\(number) \(street)"
            } else if let street = placeMark?.addressDictionary?["street"] as? String {
                address = street
            } else {
                address = city
            }
            
            completion?(LocationModel(id: "", lat: coordinates.0, lng: coordinates.1, location: "\(address), \(city)"))
        }
        
        //          } // end of getCurrentLocation
    }
}

// MARK: - GMSAutocompleteFetcherDelegate
extension LocationService: GMSAutocompleteFetcherDelegate {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        var data: [LocationModel] = []
        
        for prediction in predictions {
            //     rewrite the funiton due to the change in Google Place API 3.0
            //            if let id = prediction.placeID {
            let model = LocationModel(id: prediction.placeID, lat: nil, lng: nil, location: prediction.attributedFullText.string)
            data.append(model)
            //            }
        }
        delegate?.didUpdateSearchResult(data: data)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
        print(error.localizedDescription)
        delegate?.didFail(error: error.localizedDescription)
    }
}
