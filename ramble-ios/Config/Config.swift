//
//  Config.swift
//  Ramble
//
//  Created by Hexiao Zhang on 31/05/2020.
//  Copyright © 2020 Benjamin. All rights reserved.
//

import Foundation

struct Config {
    
    static let isProd = true
    
    struct Parse {
        private static let appId = "ramble-parse-qSDleB8UaJO8s0gtkBDVeBn0buj1Tk"
        private static let url = "https://ramble-parse.herokuapp.com/parse"
        
        private static let devAppId = "ramble-parse-dev-858yZLn6ez1MukVoHMU7RF0WA3rUXc"
// for connecting the gurana server/development database
//        private static let devUrl = "https://ramble-parse-dev.herokuapp.com/parse"
// for connecting the localhost server/development database
        private static let devUrl = "http://localhost:1337/parse"
// for connecting the remote ngrok server/development database
//        private static let devUrl = "http://7df5af410aef.ngrok.io/parse"
        /** Return Credentials according to isProd value */
        static var credentials: (appId: String, url: String) {
            if isProd {
                return (appId: Parse.appId, url: Parse.url)
            } else {
                return (appId: Parse.devAppId, url: Parse.devUrl)
            }
        }
    }
    
    struct App {
        /** Identifier on iTunes connect. Used for Rate the App URL */
        static let appStoreId = "1451355044"
        static let shareLink = ""
    }
    
    struct GooglePlaces {
        static let key = "AIzaSyC8jtWZ1vGk_dSKK14R2yxRS3r0Wy8_IOs"
    }
    
    struct StripeKey {
        private static let dev = "pk_test_YMSChuXymTqBCSqZMVxA2pTW"
        private static let prod = "pk_live_FUppdaETNVj8NnSZ2ankNadX"
        
        /** Return key according to isProd value */
        // FIXME: - Add prod or dev according to
        static var key: String {
            return isProd ? prod : dev
        }
    }
    
    struct DiscoveryAPiSettings {
        static let rootUrl = "https://app.ticketmaster.com/discovery/v2"
    }
}
