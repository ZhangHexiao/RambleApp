//
//  LocationController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

protocol LocationControllerDelegate: class {
    func didSelect(location: String?, coordinates: (lat: Double, lng: Double)?)
}

class LocationController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: LocationViewModel = LocationViewModel()
    weak var delegate: LocationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
        searchTextField.delegate = self
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "Location".localized
    }
    
    // MARK: Layout
    private func loadLayout() {
        let placeHolderAttributes = NSMutableAttributedString(string: "Search for an address".localized,
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.AppColors.searchTextHolderGray,
                                                                           NSAttributedString.Key.font: Fonts.Futura.medium.size(16)])
        
        searchTextField.attributedPlaceholder = placeHolderAttributes
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: SimpleTextCell.self)
        tableView.registerNib(cellClass: UserLocationCell.self)
    }
}

extension LocationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.locationCellType {
        case .user:
            let cell = tableView.dequeue(cellClass: UserLocationCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.userLocation?.location ?? "")
            return cell
            
        case .places:
            let cell = tableView.dequeue(cellClass: SimpleTextCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.locations[indexPath.row].location ?? "", color: .white)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }
}

// MARK: - LocationViewModelDelegate
extension LocationController: LocationViewModelDelegate {
    func didFail(error: String) {
        showError(err: error)
    }
    
    func didSelect(location: LocationModel) {
        guard let lat = location.lat, let lng = location.lng else {
            showError(err: RMBError.unknown.localizedDescription)
            return
        }
        
        delegate?.didSelect(location: location.location, coordinates: (lat, lng))
        navigationController?.popViewController(animated: true)
    }
    
    func didUpdateContent() {
        tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension LocationController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            if textField.text!.trim().isEmpty {
                viewModel.locationCellType = .user
                tableView.reloadData()
            }
            return true
        }
        
        viewModel.searchTimer?.invalidate()
        viewModel.searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (_) in
            self?.viewModel.search(text: textField.text!)
        })
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.trim().isEmpty {
            viewModel.locationCellType = .user
            tableView.reloadData()
        } else {
            viewModel.search(text: textField.text!)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.locationCellType = .places
        tableView.reloadData()
    }
}

extension LocationController {
    static var instance: LocationController {
        guard let vc = Storyboard.EventCreation.viewController(for: .location) as? LocationController else {
            assertionFailure("Something wrong while instantiating LocationController")
            return LocationController()
        }
        return vc
    }
}
