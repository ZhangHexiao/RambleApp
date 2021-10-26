//
//  MapViewModel.swift
//  ramble-ios
//
//  Created by Samanta Clara Coutinho Rondon do Nascimento on 2018-09-26.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol MapViewModelDelegate: class {
    func didLoadData()
    func didSuccess(msg: String)
    func didFail(error: String)
    func didSelect(event: Event)
}

class MapViewModel {
    
    weak var delegate: MapViewModelDelegate?
    
    var events: [Event] = []
    var eventSelected: Event?
    
    func loadData(for coordinates: (lat: Double, lng: Double)) {
        EventManager().allForMap(with: coordinates) { [weak self] (events, error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
                return
            }
            
            self?.events = events
            self?.delegate?.didLoadData()
        }
    }
    
    func selectEvent(event: Event) {
        // Already select, doesn't do anything
        if event.objectId == eventSelected?.objectId {
            return
        }
        
        eventSelected = event
        delegate?.didSelect(event: event)
    
    }
}
