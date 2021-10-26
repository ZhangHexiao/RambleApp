//
//  MapController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import Mapbox

class MapController: BaseController {
    
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var eventView: EventView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var viewModel: MapViewModel = MapViewModel()
    var selectedAnnotation: MGLAnnotation?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupMapTapGesture()
        loadMap()
        setupEventViewTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEvents()
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationAuthorization()
        
        hideBottomView(animated: false)
        unselectEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: SET UP TAP GESTURE
    private func setupMapTapGesture() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
    }
    
    private func setupEventViewTapGesture() {
        eventView.isUserInteractionEnabled = true
        eventView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEventTap(sender:))))
    }
    
    // MARK: Load data
    private func loadEvents() {
        showLoading()
        
        viewModel.loadData(for: (lat: mapView.centerCoordinate.latitude,
                                 lng: mapView.centerCoordinate.longitude))
    }
    
    private func loadMap() {
        refreshBtn.setTitle("Refresh map".localized, for: .normal)
        mapView.styleURL = MGLStyle.darkStyleURL
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 9
    }
    
    @IBAction func actionRefresh() {
        hideBottomView(animated: true)
        unselectEvent()
        loadEvents()
    }
    
    @IBAction func actionMoveToUserLocation() {
        if let coordinates = mapView.userLocation?.coordinate {
            if coordinates.latitude > -90,
                coordinates.latitude < 90,
                coordinates.longitude > -90,
                coordinates.longitude < 90 {
                    mapView.setCenter(coordinates, animated: true)

            } else {
                mapView.userTrackingMode = .follow
                mapView.zoomLevel = 9
                checkLocationAuthorization()
            }
        } else {
            showError(err: RMBError.allowUserLocation.localizedDescription)
            checkLocationAuthorization()
        }  
    }
    
    private func checkLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                mapView.setCenter(CLLocationCoordinate2D(latitude: Const.Map.montrealLatLng.lat,
                                                         longitude: Const.Map.montrealLatLng.lng),
                                  zoomLevel: 9,
                                  animated: true)
                createSettingsAlert(appSettings: true)
                
            case .authorizedAlways, .authorizedWhenInUse: break
            }
        } else {
            mapView.setCenter(CLLocationCoordinate2D(latitude: Const.Map.montrealLatLng.lat,
                                                     longitude: Const.Map.montrealLatLng.lng),
                              zoomLevel: 9,
                              animated: true)
            createSettingsAlert(appSettings: false)
        }
    }
    
    @objc private func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            hideBottomView(animated: true)
            unselectEvent()
        }
    }
    
    @objc private func handleEventTap(sender: UITapGestureRecognizer) {
        guard let event = viewModel.eventSelected else {
            return
        }
        
        let eventDetailsViewModel = ExpDetailViewModel(event: event)
        let eventDetail = ExpDetailController(viewModel: eventDetailsViewModel)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(eventDetail, animated: true)
    }
    
    private func reloadMapAnnotations() {
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        mapView.addAnnotations(viewModel.events)
    }
    
    private func unselectEvent() {
        viewModel.eventSelected = nil
        reloadMapAnnotations()
    }
}

// MARK: - HomeViewModelDelegate
extension MapController: MapViewModelDelegate {
    func didLoadData() {
        stopLoading()
        reloadMapAnnotations()
    }
    
    func didSelect(event: Event) {
        reloadMapAnnotations()
        
        showBottomView(animated: true)
        eventView.configure(with: EventViewModel(event: event))
    }
    
    func didFail(error: String) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
    }
    
    func didSuccess(msg: String) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
    }
}

// MARK: - MGLMapViewDelegate
extension MapController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {

        let reuseIdentifier = "\(annotation.coordinate)"
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier)
        
        if annotationImage == nil {
            let image = UIImage(named: "pin_map")
            annotationImage = MGLAnnotationImage(image: image ?? UIImage(), reuseIdentifier: reuseIdentifier)
        }
        
        guard let event = annotation as? Event else { return annotationImage }
        
        if event.objectId == viewModel.eventSelected?.objectId {
            annotationImage?.image = UIImage(named: "selected_pin_map")
        } else {
            annotationImage?.image = UIImage(named: "pin_map")
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // Check select
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let event = annotation as? Event else { return }
        viewModel.selectEvent(event: event)
    }
}

// MARK: - UIAlertViewDelegate
extension  MapController: UIAlertViewDelegate {
    
    private func createSettingsAlert(appSettings: Bool) {
        RMBAlert.settingsLocation.show(on: self) { [weak self] _ in
            self?.selectSettingsPath(appSettings)
        }
    }
    
    private func selectSettingsPath(_ appSettings: Bool) {
        if appSettings {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "App-Prefs:root")!, options: [:], completionHandler: nil)
        }
    }
    
}

// MARK: - BottomView animations
extension MapController {
    private func showBottomView(animated: Bool) {
        bottomViewBottom.constant = 8
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func hideBottomView(animated: Bool) {
        bottomViewBottom.constant = -(102 + 8)
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
}
    
extension MapController {
    static var instance: MapController {
        guard let vc = Storyboard.Map.viewController(for: .map) as? MapController else {
            assertionFailure("Something wrong while instantiating MapController")
            return MapController()
        }
        return vc
    }
}
