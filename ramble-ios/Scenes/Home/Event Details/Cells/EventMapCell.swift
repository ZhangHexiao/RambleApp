//
//  EventMapCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import Mapbox

class EventMapCell: UITableViewCell {
    
    var mapView: MGLMapView?
    
    weak var delegate: EventDetailsSelectLocationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView = MGLMapView(frame: bounds, styleURL: URL(string: Const.Map.style))
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.backgroundColor = UIColor.clear
            mapView.tintColor = UIColor.white
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(mapView)
        }
    }
    
    func configure(with coordinates: (Double, Double), delegate: EventDetailsSelectLocationDelegate?) {
        self.delegate = delegate
        
        if let annotations = mapView?.annotations {
            mapView?.removeAnnotations(annotations)
        }
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1)
        mapView?.addAnnotation(annotation)
        
        mapView?.setCenter(CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), zoomLevel: 13, animated: false)

    }
}

// MARK: - MGLMapViewDelegate
extension EventMapCell: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotation")
        if annotationImage == nil {
            annotationImage = MGLAnnotationImage(image: #imageLiteral(resourceName: "pin_map"), reuseIdentifier: "annotation")
        }
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        delegate?.didSelectLocation()
    }
}

extension EventMapCell {
    static var kHeight: CGFloat { return 170.0 }
}
