//
//  LocationViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-12.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol SelectCityViewModelDelegate: class {
    func didFail(error: String)
    func didUpdateContent()
    func didSelect(coordinate: (latitude:Double, longitude:Double)?, city: String?)
}

enum CityCellType {
    case user, places
}

class SelectCityViewModel {
    
    var allCities: [CityType] = CityType.all
    
    weak var delegate: SelectCityViewModelDelegate?
    
    var cityCellType: CityCellType = .user
    
    var searchTimer: Timer?
    
    var placesService: LocationService
    
    var locations: [LocationModel] = []
    
    var userLocation: LocationModel?
    
    
    init() {
        placesService = LocationService()
        currentLocation()
    }
    
    private func currentLocation() {
        placesService.getUserLocation { [weak self] (location) in
            guard let location = location else {
                self?.delegate?.didFail(error: RMBError.locationCantRetrieceUsersLocation.localizedDescription)
                return
            }
            
            self?.userLocation = location
            self?.cityCellType = .user
            self?.delegate?.didUpdateContent()
        }
    }
    
    func viewWillDisappear() {
        searchTimer?.invalidate()
        searchTimer = nil
    }
    
    func search(text: String) {
        placesService.delegate = self
        placesService.seach(text)
    }
    
    func select(at indexPath: IndexPath) {
        
        switch cityCellType {
        case .user:
            switch indexPath.section{
            case 0:
                //= We no longer need to pass the local coordinate to the backend==
                //             if let location = userLocation {
                //             delegate?.didSelect(coordinate:(latitude:location.lat!,    longitude:location.lng!)) }
                //             delegate?.didSelect(coordinate:nil)
                //             tabBarController.selectedIndex = 1
                replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
            default:
                let city = allCities[indexPath.row]
                let locationCoordinate = city.coordinate()
                delegate?.didSelect(coordinate:locationCoordinate, city: city.rawString())
            }            
        case .places:
            switch indexPath.section{
            case 0:
                if let location = userLocation {
                    delegate?.didSelect(coordinate:(latitude:location.lat!, longitude:location.lng!), city: nil)
                }
                replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
            default:
                placesService.getFullData(for: locations[indexPath.row]) { [weak self] (location) in
                    if location.lng != nil && location.lng == nil {
                        // couldn't fetch full data
                        self?.delegate?.didFail(error: RMBError.cantFetchData.localizedDescription)
                        return
                    }
                    let cityName = location.getCity()
                    let locationCoordinate = (latitude:location.lat!,longitude:location.lng!)
                    self?.delegate?.didSelect(coordinate: locationCoordinate, city: cityName)
                }
            }
            return
        }
    }
}

extension SelectCityViewModel {
    func numberOfRows() -> Int {
        switch cityCellType {
        case .user: return allCities.count
        case .places: return locations.count
        }
    }
}

// MARK: - GooglePlacesServiceDelegate
extension SelectCityViewModel: LocationServiceDelegate {
    func didUpdateSearchResult(data: [LocationModel]) {
        if !data.isEmpty {
            locations = data
            cityCellType = .places
        } else {
            if locations.isEmpty {
                cityCellType = .user
            }
        }
        delegate?.didUpdateContent()
    }
    
    func didFail(error: String) {
        delegate?.didFail(error: error)
    }
}
