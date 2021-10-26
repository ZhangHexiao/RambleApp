//
//  RMBActionSheet.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-22.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

enum RMBActionSheet {
    
    case reportOrRate
    case report
    case reportUser
    case eventActions
    case map
    // swiftlint:disable:next identifier_name
    case photo(removable: Bool)
    
    enum RMBActionSheetDetail {
        case edit, duplicate,cancel, delete, reportEvent, appleMaps, googleMaps, camera, library, removeImage, reportCover, reportProfile, rateExperience, share
    }

}

extension RMBActionSheet {
    
    public func show(on vc: UIViewController, _ action: @escaping (_ actionDetail: RMBActionSheetDetail) -> Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        switch self {
        case .reportOrRate:
            reportOrRateActions(alert, action)
        
        case .eventActions:
            eventActions(alert, action)
        
        case let .photo(removable):
            photoActions(alert, isRemovable: removable, action)
        
        case .map:
            alert.title =  "Open with...".localized
            mapActions(alert, action)
            
        case .reportUser:
            reportUserActions(alert, action)
            
        case .report:
            reportActions(alert, action)
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        show(alert: alert, on: vc)
    }
    
    private func show(alert: UIAlertController, on vc: UIViewController) {
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
}

extension RMBActionSheet {
    
    private func reportOrRateActions(_ alert: UIAlertController, _ action: @escaping (_ actionDetail: RMBActionSheetDetail) -> Void) {
        alert.addAction(UIAlertAction(title: "Rate this experience".localized, style: .default) { (_) in action(.rateExperience) })
        alert.addAction(UIAlertAction(title: "Report inappropriate content".localized, style: .default) { (_) in action(.reportEvent) })
        alert.addAction(UIAlertAction(title: "Share this experience".localized, style: .default) { (_) in action(.share) })
    }
    
    private func eventActions(_ alert: UIAlertController, _ action: @escaping (_ actionDetail: RMBActionSheetDetail) -> Void) {
        alert.addAction(UIAlertAction(title: "Edit event".localized, style: .default) { (_) in  action(.edit) })
        alert.addAction(UIAlertAction(title: "Duplicate event".localized, style: .default) { (_) in  action(.duplicate) })
        alert.addAction(UIAlertAction(title: "Cancel event".localized, style: .default) { (_) in action(.cancel) })
        alert.addAction(UIAlertAction(title: "Delete event".localized, style: .destructive) { (_) in  action(.delete) })
    }
    
    private func mapActions(_ alert: UIAlertController, _ action: @escaping (_ actionDetail: RMBActionSheetDetail) -> Void) {
        alert.addAction(UIAlertAction(title: "Maps".localized, style: .default) { (_) in  action(.appleMaps) })
        alert.addAction(UIAlertAction(title: "Google Maps".localized, style: .default) { (_) in  action(.googleMaps) })
    }
    
    private func photoActions(_ alert: UIAlertController, isRemovable: Bool = false, _ action: @escaping (_ actionDetail: RMBActionSheetDetail) -> Void) {
        alert.addAction(UIAlertAction(title: "Take Photo".localized, style: .default) { (_) in action(.camera)})
        alert.addAction(UIAlertAction(title: "Choose from Library".localized, style: .default) { (_) in action(.library) })
        
        if isRemovable {
            alert.addAction(UIAlertAction(title: "Remove image".localized, style: .destructive) { (_) in action(.removeImage) })
        }
    }
    
    private func reportUserActions(_ alert: UIAlertController, _ action: @escaping (_ actionDetail: RMBActionSheetDetail) -> Void) {
        alert.addAction(UIAlertAction(title: "Report Inappropriate cover picture".localized, style: .default, handler: { (_) in action(.reportCover)
        }))
        alert.addAction(UIAlertAction(title: "Report Inappropriate profile picture".localized, style: .default, handler: { (_) in action(.reportProfile)
        }))
    }
    
    private func reportActions(_ alert: UIAlertController, _ action: @escaping (_ actionDetail: RMBActionSheetDetail) -> Void) {
        alert.addAction(UIAlertAction(title: "Report inappropriate content".localized, style: .default) { (_) in action(.reportEvent) })
        alert.addAction(UIAlertAction(title: "Share this experience".localized, style: .default) { (_) in action(.share) })
    }
}
