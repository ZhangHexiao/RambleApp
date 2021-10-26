//
//  ContactController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class ContactController: BaseController {
    
    @IBOutlet weak var yourMessageLabel: UILabel!
    @IBOutlet weak var yourContactInfoLabel: UILabel!
    @IBOutlet weak var eventView: EventView!
    @IBOutlet weak var eventHeight: NSLayoutConstraint! // 102

    @IBOutlet weak var adminMessageLabel: UILabel!
    @IBOutlet weak var adminMessageBottom: NSLayoutConstraint! // 8

    @IBOutlet weak var emailTextField: RMBTextField!
    @IBOutlet weak var phoneTextField: RMBTextField!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    let viewModel: ContactViewModel = ContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        commentTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNavbar()
        self.loadLayout()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Contact Admin".localized
        
        let itemCancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = itemCancel
        
        let itemSend = UIBarButtonItem(title: "Send".localized, style: .plain, target: self, action: #selector(actionSend))
        navigationItem.rightBarButtonItem = itemSend
    }
    
    // MARK: Layout
    func loadLayout() {
        commentTextView.text = "Write something here".localized
        emailTextField.placeholder = "Email address".localized
        phoneTextField.placeholder = "Phone number".localized
        yourMessageLabel.text = "Your message to the admin team".localized
        yourContactInfoLabel.text = "Your contact information".localized

        switch viewModel.contactType {
        case .contactUs:
            eventView.isHidden = true
            eventHeight.constant = 0
            adminMessageLabel.isHidden = true
            adminMessageLabel.text = ""
            adminMessageBottom.constant = 0
        case .claimEvent:
            eventView.isHidden = false
            eventView.configure(with: viewModel.eventViewModel)
            eventHeight.constant = 102
            adminMessageLabel.isHidden = false
            adminMessageBottom.constant = 8
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func actionCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func actionSend() {
        showLoading()
        viewModel.send(email: emailTextField.text,
                       phone: phoneTextField.text,
                       text: commentTextView.text)
    }
    
}

extension ContactController: ContactViewModelDelegate {
    func didFail(error: String, removeFromTop: Bool) {
        self.showError(err: error)
        if removeFromTop {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didSuccess(msg: String, removeFromTop: Bool) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
        
        if removeFromTop {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITextViewDelegate
extension ContactController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write something here".localized {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write something here".localized
            textView.textColor = UIColor.AppColors.placeHolderGray
        }
    }
}

extension ContactController {
    static var instance: ContactController {
        guard let vc = Storyboard.Settings.viewController(for: .contact) as? ContactController else {
            assertionFailure("Something wrong while instantiating ContactController")
            return ContactController()
        }
        return vc
    }
}
