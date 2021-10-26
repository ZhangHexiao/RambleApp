//
//  ForceUpdate.swift
//  GCReno-ios
//
//  Created by Omran on 2019-01-28.
//  Copyright © 2019 Omran. All rights reserved.
//

import Foundation
import UIKit

public enum Environment {
    case appStore, testFlight, crashlytics, enterprise
}

// MARK: - Public

open class ForceUpdate {
    
    /**
     *  Get default default view controller for blocking user.
     *
     *  @param installationUrl      The url to download and install the update
     *  @param environment          The environment target
     *
     *  @return ForceUpdateViewController instance
     */
    public static func viewController(for installationUrl: String, environment: Environment) -> ForceUpdateViewController {
        let viewController = ForceUpdateViewController(nibName: nil, bundle: nil)
        viewController.installationUrl = installationUrl
        viewController.view.backgroundColor = .white
        
        return viewController
    }
    
    /**
     *  Check if the current build is outdated.
     *
     *  @param minVersion   The minimal version to run the app
     *  @param minBuild  The minimal build number to run the app
     *  @param environment  The environment target
     *
     *  @return true if the build is outdated
     */
    public static func isBuildOutdated(for minVersion: String, minBuild: String, environment: Environment) -> Bool {
        var version = ""
        if environment == .appStore {
            version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        } else {
            version = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        }
        return compare(minVersion: minVersion, to: version) == .orderedDescending
    }
    
}

// MARK: Private

extension ForceUpdate {
    
    // MARK: Version comparator
    
    fileprivate static func compare(minVersion: String, to version: String) -> ComparisonResult {
        var result: ComparisonResult = .orderedSame
        guard minVersion != version else {return result}
        
        let minimumVersionComponents: [Int] = minVersion.components(separatedBy: ".").filter({return Int($0) != nil}).map({return Int($0)!})
        let comparingVersionComponents: [Int] = version.components(separatedBy: ".").filter({return Int($0) != nil}).map({return Int($0)!})
        
        for (index, component) in minimumVersionComponents.enumerated() {
            
            // segments have to be integers
            var comparingVersionComponent: Int = 0
            if index < comparingVersionComponents.count {
                comparingVersionComponent = comparingVersionComponents[index]
            }
            
            if component < comparingVersionComponent {
                result = .orderedAscending
                break
            }
            
            if component > comparingVersionComponent {
                result = .orderedDescending
                break
            }
            
        }
        
        if result == .orderedSame, comparingVersionComponents.count > minimumVersionComponents.count {
            result = .orderedAscending
        }
        
        return result
    }
    
}

