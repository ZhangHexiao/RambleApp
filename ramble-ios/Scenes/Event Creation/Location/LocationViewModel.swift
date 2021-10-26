//
//  LocationViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-12.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol LocationViewModelDelegate: class {
    func didFail(error: String)
    func didUpdateContent()
    func didSelect(location: LocationModel)
}

enum LocationCellType {
    case user, places
}

class LocationViewModel {
    
    weak var delegate: LocationViewModelDelegate?
    
    var locationCellType: LocationCellType = .user
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
            self?.locationCellType = .user
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
        switch locationCellType {
        case .user:
            if let location = userLocation {
                delegate?.didSelect(location: location)
            }
        case .places:
            // return place selected after fetching its lat and lng
            placesService.getFullData(for: locations[indexPath.row]) { [weak self] (location) in
                if location.lng != nil && location.lng == nil {
                    // couldn't fetch full data
                    self?.delegate?.didFail(error: RMBError.cantFetchData.localizedDescription)
                    return
                }
                self?.delegate?.didSelect(location: location)
            }
        }
    }
}

extension LocationViewModel {
    func numberOfRows() -> Int {
        switch locationCellType {
        case .user: return userLocation == nil ? 0 : 1
        case .places: return locations.count
        }
    }
}

// MARK: - GooglePlacesServiceDelegate
extension LocationViewModel: LocationServiceDelegate {
    func didUpdateSearchResult(data: [LocationModel]) {
        if !data.isEmpty {
            locations = data
            locationCellType = .places
        } else {
            if locations.isEmpty {
                locationCellType = .user
            }
        }
        delegate?.didUpdateContent()
    }
    
    func didFail(error: String) {
        delegate?.didFail(error: error)
    }
}
