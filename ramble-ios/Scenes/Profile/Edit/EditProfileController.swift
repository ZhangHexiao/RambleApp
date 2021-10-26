//
//  EditProfileController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import TOCropViewController

enum EditProfilePhotoType {
    case profile, cover
}

class EditProfileController: BaseController {
    
    @IBOutlet weak var firstNameTextField: RMBTextField!
    @IBOutlet weak var lastNameTextField: RMBTextField!
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var userImage: RMBRoundImage!
    
    @IBOutlet weak var addCoverButton: UIButton!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var changeCoverButton: UIButton!
    
    @IBOutlet weak var saveButton: RMBButton!
    
    var viewModel = EditProfileViewModel()
    let imagePicker = UIImagePickerController()
    var selectEditProfilePhotoType: EditProfilePhotoType = .profile
    var fromBlock: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false

        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        
        navigationItem.hidesBackButton = true
        switch viewModel.viewType {
        case .edit:
            let itemCancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(actionCancel))
            navigationItem.leftBarButtonItem = itemCancel
            
            let itemSave = UIBarButtonItem(title: "Save".localized, style: .plain, target: self, action: #selector(actionMenuSave))
            navigationItem.rightBarButtonItem = itemSave
        case .setup: break
        }
        
        title = viewModel.title
    }
    
    // MARK: Layout
    
    private func loadLayout() {
        switch viewModel.viewType {
        case .edit:
            saveButton.isHidden = true
        case .setup:
            saveButton.isHidden = false
        }
    }
    
    private func coverLayout(isEmpty: Bool) {
        coverImage.image = viewModel.coverImage
        addCoverButton.isHidden = !isEmpty
        changeCoverButton.isHidden = isEmpty
    }
    
    private func profileLayout(isEmpty: Bool) {
        userImage.image = viewModel.profileImage ?? #imageLiteral(resourceName: "ic_user")
        changeProfileButton.setImage(isEmpty ? #imageLiteral(resourceName: "ic_add") : #imageLiteral(resourceName: "ic_edit_filled"), for: .normal)
    }
    
    // MARK: - Data
    private func initData() {
        viewModel.initData(user: User.current())
        firstNameTextField.text = viewModel.name
        lastNameTextField.text = viewModel.lastName
        saveButton.setTitle("Save profile".localized, for: .normal)
        firstNameTextField.placeholder = "First name".localized
        lastNameTextField.placeholder = "Last name".localized
    }
    
    // MARK: - Actions
    @IBAction func actionSave() {
        if prepareToSave() {
            viewModel.save()
        }
    }
    
    @IBAction func actionChangeCover() {
        selectEditProfilePhotoType = .cover
        showCameraAlert()
    }
    
    @IBAction func actionChangeProfile() {
        selectEditProfilePhotoType = .profile
        showCameraAlert()
    }
    
    @objc private func actionCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // Save from the Menu tabbar, it only is shown when setting up the profile
    @objc private func actionMenuSave() {
        if prepareToSave() {
            viewModel.save()
        }
    }
    
    private func prepareToSave() -> Bool {
        
        if viewModel.validate(text: firstNameTextField.text!) {
            firstNameTextField.becomeFirstResponder()
            return false
        }
        
        if viewModel.validate(text: lastNameTextField.text!) {
            lastNameTextField.becomeFirstResponder()
            return false
        }
        
        viewModel.name = firstNameTextField.text
        viewModel.lastName = lastNameTextField.text
        viewModel.addImagesToUser()
        return true
    }
}

// MARK: - EditProfileViewModelDelegate
extension EditProfileController: EditProfileViewModelDelegate {
    
    func didFail(error: String) {
        showError(err: error)
    }
    
    func didLoadCoverImage() {
        coverLayout(isEmpty: viewModel.coverImage == nil)
    }
    
    func didLoadProfileImage() {
        profileLayout(isEmpty: viewModel.profileImage == nil)
    }
    
    func didSave() {
        switch viewModel.viewType {
        case .edit:
            showSuccess(success: "Profile saved!".localized)
            navigationController?.popViewController(animated: true)
        case .setup:
            if fromBlock {
                GRNNotif.guestLoggedIn.postNotif(nil)
                dismiss(animated: true)
            } else {
                replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Camera Methods
extension EditProfileController {
    private func showCameraAlert() {
        
        var isRemovable = false
        switch selectEditProfilePhotoType {
        case .profile: isRemovable = viewModel.profileImage != nil
        case .cover: isRemovable = viewModel.coverImage != nil
        }
        
        RMBActionSheet.photo(removable: isRemovable).show(on: self) { [weak self] (actionDetail) in
            switch actionDetail {
            case .camera: self?.launchCamera()
            case .library: self?.launchImagePicker()
            case .removeImage: self?.removeImage()
                
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
    
    private func removeImage() {
        switch selectEditProfilePhotoType {
        case .profile:
            viewModel.profileImage = nil
            userImage.image = nil
            profileLayout(isEmpty: true)
        case .cover:
            viewModel.coverImage = nil
            coverImage.image = nil
            coverLayout(isEmpty: true)
        }
    }
}

// MARK: - ImagePickerDelegate
extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImage: UIImage?
        
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        } else {
            showError(err: RMBError.unknown.localizedDescription)
        }
        
        switch selectEditProfilePhotoType {
        case .cover:
            viewModel.coverImage = selectedImage
            coverLayout(isEmpty: selectedImage == nil)
            dismiss(animated: true, completion: nil)

        case .profile:
            
            let cropViewController = TOCropViewController(croppingStyle: .circular, image: selectedImage ?? #imageLiteral(resourceName: "ic_user"))
            cropViewController.delegate = self
            
            if picker.sourceType == .camera {
                dismiss(animated: true, completion: {
                    self.present(cropViewController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropViewController, animated: true)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        viewModel.profileImage = image
        profileLayout(isEmpty: false)
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController {
    static var instance: EditProfileController {
        guard let vc = Storyboard.Profile.viewController(for: .editProfile) as? EditProfileController else {
            assertionFailure("Something wrong while instantiating EditProfileController")
            return EditProfileController()
        }
        return vc
    }
}
