//
//  NewEventController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import TOCropViewController

protocol NewEventControllerDelegate: class {
    func didUpdateEvent()
}

class NewEventController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: RMBButton!
    
    var viewModel: NewEventViewModel
    var tableViewDataSource: NewEventDataSource?

    weak var delegate: NewEventControllerDelegate?

    let imagePicker = UIImagePickerController()

    public init() {
        self.viewModel = NewEventViewModel(event: nil, eventType: .new)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    public init(viewModel: NewEventViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        
        NewEventDataSource.setupNewEvent(tableView: tableView)
        tableViewDataSource = NewEventDataSource(viewModel: viewModel, delegate: self)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDataSource
        tableView.contentInsetAdjustmentBehavior = .automatic
        sendButton.setTitle("Post".localized, for: .normal)
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationItem.hidesBackButton = true
        title = viewModel.title
        
        let itemCancel =  UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = itemCancel
    }
    
    // MARK: - Actions
    @IBAction func actionSend() {
        if let error = viewModel.validateEvent() {
            showError(err: error)
        } else {
            viewModel.save()
            showLoading()
        }
    }
    
    @objc private func actionCancel() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - NewEventViewModelDelegate
extension NewEventController: NewEventViewModelDelegate {
    func didFail(error: String) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
    }
    
    func didSaveSuccess() {
        stopLoading { [weak self] in
            self?.goEventDetails()
        }
    }
    
    private func goEventDetails() {
        switch viewModel.eventType {
        case .new:
            showSuccess(success: "New Event!".localized)
            let eventDetail = ExpDetailController(viewModel: ExpDetailViewModel(event: viewModel.event!))
            guard let navigationControllerIndex = navigationController?.viewControllers.count else {
                navigationController?.popViewController(animated: true)
                return
            }
            navigationController?.viewControllers[navigationControllerIndex-1] = eventDetail
        case .edit:
            showSuccess(success: "Event updated!".localized)
            delegate?.didUpdateEvent()
            navigationController?.popViewController(animated: true)
        case .duplicate:
            showSuccess(success: "Event duplicate!".localized)
            delegate?.didUpdateEvent()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didUpdateContent() {
        tableView.reloadData()
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
}

// MARK: - NewEventViewModelDelegate
extension NewEventController: LocationControllerDelegate {
    func didSelect(location: String?, coordinates: (lat: Double, lng: Double)?) {
        viewModel.location = location
        viewModel.lat = coordinates?.lat
        viewModel.lng = coordinates?.lng
        tableView.reloadData()
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
}

// MARK: - CategoriesControllerDelegate
extension NewEventController: CategoriesControllerDelegate {
    func didSelect(category: CategoryType) {
        viewModel.category = category.rawString()
        tableView.reloadData()
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
}

// MARK: - SelectDateControllerDelegate
extension NewEventController: SelectDateControllerDelegate {
    func didSelect(date: Date, type: DateType) {
        viewModel.update(date, for: type)
        tableView.reloadData()
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
}

// MARK: - Camera picker content
extension NewEventController {
    
    private func showCameraAlert() {
        RMBActionSheet.photo(removable: false).show(on: self) { [weak self] (actionDetail) in
            switch actionDetail {
            case .camera: self?.launchCamera()
            case .library: self?.launchImagePicker()
            default: break
            }
        }
    }
    
    private func launchCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func launchImagePicker() {
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: {
            self.imagePicker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .white
        })
    }
}

// MARK: - ImagePickerDelegate
extension NewEventController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage

        let cropViewController = TOCropViewController(croppingStyle: .default, image: selectedImage ?? #imageLiteral(resourceName: "ic_user"))
        cropViewController.delegate = self
        if picker.sourceType == .camera {
            dismiss(animated: true, completion: {
                self.present(cropViewController, animated: true, completion: nil)
            })
        } else {
            picker.pushViewController(cropViewController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TOCropViewControllerDelegate
extension NewEventController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        viewModel.eventImage = image
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
}

extension NewEventController: NewEventDataSourceDelegate {
    func switchCellDidChange(status: Bool) {
        viewModel.isBookingRequired = status
        tableViewDataSource?.inject(viewModel: viewModel)
        tableView.reloadData()
    
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
    
    func didTapSelectCategory() {
        let categories = CategoriesController.instance
        categories.delegate = self
        categories.categorySelected = viewModel.categoryType() ?? .arts
        navigationController?.pushViewController(categories, animated: true)
    }
    
    func didTapSelectDate(type: DateType) {
        let selectDate = SelectDateController.instance
        selectDate.viewModel.dateType = type
        selectDate.delegate = self

        switch type {
        case .startAt:
            selectDate.viewModel.injectDate(date: viewModel.startAt)
        case .endAt:
            selectDate.viewModel.injectDate(date: viewModel.endAt, minimumDate: viewModel.startAt)
        }
        navigationController?.pushViewController(selectDate, animated: true)
    }
    
    func didTapSelectLocation() {
        let location = LocationController.instance
        location.delegate = self
        navigationController?.pushViewController(location, animated: true)
    }
    
    func didUpdateTableViewHeight(indexPath: IndexPath) {
        
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        tableView.beginUpdates()
        tableView.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func didTapToShowCamera() {
        showCameraAlert()
    }
    
    func didEndEditing(text: String, for type: ExpandingFieldType) {
        viewModel.update(text, for: type)
        tableViewDataSource?.inject(viewModel: viewModel)
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
// ===Add function for duplicating event========
    func didEndDuplicating(text: String, for type: ExpandingFieldType) {
        viewModel.update(text, for: type)
        tableViewDataSource?.inject(viewModel: viewModel)
        sendButton.theme = viewModel.sendButtonTheme().rawValue
    }
// ============================================
}
