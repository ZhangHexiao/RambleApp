//
//  Const.swift
//
//  Created by Benjamin Bourasseau on 19/01/2016.
//  Copyright © 2016 Benjamin. All rights reserved.
//

import Foundation
import UIKit

typealias SuccessHandler = ((_ success: Bool, _ error: String?) -> Void)?

struct Const {

    static let radius = 30
    
    struct NSUserDefaultsKey {
        static let fromDateForHome = "fromDateForHome"
        static let toDateForHome = "toDateForHome"
        static let categoriesForHome = "categoriesForHome"
        static let fromDateForSearch = "fromDateForSearch"
        static let toDateForSearch = "toDateForSearch"
        static let categoriesForSearch = "categoriesForSearch"
    }
    
    struct Url {
        static let shareLinkDev = "https://ramble.wimmo.es/events/"
        static let shareLinkProd = "https://www.rambleworld.com/events/"
        private static let appStoreLink = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews"
        static let appStoreRating = "\(appStoreLink)?id=\(Config.App.appStoreId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
        static let appStoreDownload = "itms-apps://itunes.apple.com/app/x-gift/id\(Config.App.appStoreId)?mt=8&uo=4"
        
        static func appleMapUrl(coordinates: (lat: Double, lng: Double)) -> URL? {
            return URL(string: "http://maps.apple.com/?daddr=\(coordinates.lat),\(coordinates.lng)")
        }
        
        static func googleMapUrl(coordinates: (lat: Double, lng: Double)) -> URL? {
            return URL(string: "comgooglemaps://?saddr=&daddr=\(coordinates.lat)),\(coordinates.lng)")
        }
        
        static var shareLink: String {
            return Config.isProd ? shareLinkProd : shareLinkDev
        }
    }
    
    struct Map {
        static let style = "mapbox://styles/mapbox/dark-v9"
        static let montrealLatLng = (lat: 45.50884, lng: -73.58781)
    }
}

struct Fonts {
    enum HelveticaNeue: String {
        case light = "Light",
        medium = "Medium",
        bold = "bold",
        condensedExtraBold = "CondensedExtraBold"
        
        func size(_ size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-\(self.rawValue)", size: size)!
        }
    }
    
    enum Futura: String {
        case medium = "Medium",
        condensedMedium = "CondensedMedium",
        mediumItalic = "MediumItalic",
        condensedExtraBold = "CondensedExtraBold"
        
        func size(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Futura-\(self.rawValue)", size: size)!
        }
    }
    
    enum Helvetica: String {
        case oblique = "Oblique",
        light = "Light",
        bold = "Bold",
        boldOblique = "BoldOblique",
        lightOblique = "LightOblique"
        
        func size(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Helvetica-\(self.rawValue)", size: size)!
        }
    }
}
