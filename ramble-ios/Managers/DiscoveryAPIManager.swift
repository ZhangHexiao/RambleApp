//
//  DiscoveryAPIManager.swift
//  ramble-ios
//
//  Created by Omran on 2019-05-14.
//  Copyright © 2019 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class DiscoveryAPIManager {

    private let userDefaults = UserDefaults.standard
    private var baseURl = Config.DiscoveryAPiSettings.rootUrl
    static let shared: DiscoveryAPIManager = DiscoveryAPIManager()
    
    private init() { }

    func updateEvents() {
        if shouldUpdateEvents() {
            let placesService = LocationService()
            placesService.getUserLocation { (location) in
                guard let location = location else {
                    print("error getting user location")
                    return
                }
                PFCloud.callFunction(inBackground: "checkForNearByEvents", withParameters: ["latitude": location.lat ?? "", "longtude": location.lng ?? ""]) { [weak self] _, error in
                    print("finish updating events: \(error?.localizedDescription ?? "SUCCESS")")
                    self?.setLastTimeEventsUpdated(date: Date())
                }
            }
        }
    }
}

extension DiscoveryAPIManager {
    private func setLastTimeEventsUpdated(date: Date) {
        userDefaults.setValue(date, forKey: "LastTimeEventsUpdated")
    }
    
    private func getLastTimeEventsUpdated() -> Date? {
        if let date = userDefaults.value(forKey: "LastTimeEventsUpdated") as? Date {
            return date
        }
        return nil
    }
    
    private func shouldUpdateEvents() -> Bool {
        if let lastTimeUpdated = getLastTimeEventsUpdated() {
            let current = Date()
            let components = Calendar.current.dateComponents([.hour], from: lastTimeUpdated, to: current)
            return components.hour ?? 0 > 3 ? true : false
        } else {
            return true
        }
    }
}
