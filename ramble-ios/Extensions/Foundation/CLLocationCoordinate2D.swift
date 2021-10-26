//
//  CLLocationCoordinate2D.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-27.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
