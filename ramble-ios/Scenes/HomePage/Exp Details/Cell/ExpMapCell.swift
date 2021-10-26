//
//  EventMapCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-10.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import Mapbox

class ExpMapCell: UITableViewCell {
    
    var mapView: MGLMapView?
    var customeAnotition: MGLAnnotationView?
    var customeImageAnotition: MGLAnnotationImage?
    var backgroundImageView: UIImageView = {
         let imageView = UIImageView(frame: .zero)
         imageView.image = UIImage(named: "locationRange.png")
         imageView.contentMode = .scaleToFill
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
    
    weak var delegate: EventDetailsSelectLocationDelegate?
    var location: (Double, Double)?
//    class var zoomLevelVariable: NSExpression { get }
    
    override func awakeFromNib() {
        
       super.awakeFromNib()
        
       let reuseIdentifier = "annotationView"

       customeAnotition = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
       customeAnotition!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
         
        mapView = MGLMapView(frame: bounds, styleURL: URL(string: Const.Map.style))
        if let mapView = mapView {
            mapView.delegate = self
            mapView.backgroundColor = UIColor.clear
            mapView.tintColor = UIColor.white
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.minimumZoomLevel = 12
            mapView.maximumZoomLevel = 18
            addSubview(mapView)
        }
    }
    
    func configure(with coordinates: (Double, Double), delegate: EventDetailsSelectLocationDelegate?) {
        self.delegate = delegate
        self.location = coordinates
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
extension ExpMapCell: MGLMapViewDelegate {
//    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
////        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "annotation")
////        if annotationImage == nil {
////            annotationImage = MGLAnnotationImage(image: #imageLiteral(resourceName: "bg_green_band"), reuseIdentifier: "annotation")
////        }
//        return self.customeImageAnotition
//    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        let backgroundImage = UIImageView()
//        backgroundImage.clipsToBounds = true
//        backgroundImage.image = UIImage(named: "locationRange.png")
//        backgroundImage.contentMode = .scaleToFill
//        self.customeAnotition?.addSubview(backgroundImage)
//        backgroundImage.frame = backgroundImage.superview?.bounds as! CGRect
//        self.customeAnotition?.backgroundColor = UIColor(patternImage: UIImage(named: "locationRange.png")!)
//        self.customeAnotition?.backgroundColor = .black
        
        customeAnotition?.insertSubview(backgroundImageView, at: 0)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: customeAnotition!.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: customeAnotition!.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: customeAnotition!.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: customeAnotition!.bottomAnchor)
        ])
         return self.customeAnotition
    }
    
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
            self.customeAnotition!.bounds = CGRect(x: 0, y: 0, width: 40 * pow(2,mapView.zoomLevel-13), height: 40 * pow(2, mapView.zoomLevel-13))
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        delegate?.didSelectLocation()
    }
}

extension ExpMapCell {
    static var kHeight: CGFloat { return 170.0 }
}
