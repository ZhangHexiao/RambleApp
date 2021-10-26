//
//  SelectCityController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2019-12-27.
//  Copyright © 2019 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

protocol SelectCityControllerDelegate: class {
    func didSelect(coordinate: (latitude: Double, longitude: Double)?, city: String?)
}

protocol ChangeCityControllerDelegate: class {
    func didChange(coordinate: (latitude: Double, longitude: Double)?, city: String?)
}

class SelectCityController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: SelectCityViewModel = SelectCityViewModel()
    weak var delegate: SelectCityControllerDelegate?
    weak var delegateCity: ChangeCityControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        setupTableView()
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
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "Change Location"
    }
    
    // MARK: Layout
    private func loadLayout() {
        let placeHolderAttributes = NSMutableAttributedString(string: "Search location",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.AppColors.searchTextHolderGray,
                                                                           NSAttributedString.Key.font: Fonts.Futura.medium.size(16)])
        
        searchTextField.attributedPlaceholder = placeHolderAttributes
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: CityCell.self)
        tableView.registerNib(cellClass: SimpleTextCell.self)
        tableView.registerNib(cellClass: UserLocationCell.self)

    }
}

extension SelectCityController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return viewModel.userLocation == nil ? 0 : 1
        case 1:
            return viewModel.numberOfRows()
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.cityCellType {
            
        case .user:
            switch indexPath.section{
            case 0:
            let cell = tableView.dequeue(cellClass: UserLocationCell.self, indexPath: indexPath)
                cell.configure(with: "Use current location")
            return cell
            default:
            let city = viewModel.allCities[indexPath.row]
            let cell = tableView.dequeue(cellClass: CityCell.self, indexPath: indexPath)
                cell.configure(with: city)
            return cell
                }
            
        case .places:
            switch indexPath.section{
            case 0:
            let cell = tableView.dequeue(cellClass: UserLocationCell.self, indexPath: indexPath)
            cell.configure(with: "Use current location")
            return cell
            default:
            let cell = tableView.dequeue(cellClass: SimpleTextCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.locations[indexPath.row].location ?? "", color: .white)
            return cell
            }
                 
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 0:
        return UITableView.automaticDimension
        default:
        return CityCell.kHeight
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }
}

// MARK: - SelectCityViewModelDelegate
extension SelectCityController: SelectCityViewModelDelegate {
    func didSelect(coordinate: (latitude: Double, longitude: Double)?, city: String?) {
        if coordinate != nil{
            delegate?.didSelect(coordinate: coordinate, city: city)
              delegateCity?.didChange(coordinate: coordinate, city: city)
            navigationController?.popViewController(animated: true)
        }
        else {
            showError(err: RMBError.unknown.localizedDescription)
            return
        }
    }
    
    func didFail(error: String) {
        showError(err: error)
    }
    
    func didUpdateContent() {
        tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension SelectCityController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            if textField.text!.trim().isEmpty {
                viewModel.cityCellType = .user
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
            viewModel.cityCellType = .user
            tableView.reloadData()
        } else {
            viewModel.search(text: textField.text!)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.cityCellType = .places
        tableView.reloadData()
    }
}

extension SelectCityController {
    static var instance: SelectCityController {
        guard let vc = Storyboard.Searchevent.viewController(for: .selectCity) as? SelectCityController else {
            assertionFailure("Something wrong while instantiating LocationController")
            return SelectCityController()
        }
        return vc
    }
}

