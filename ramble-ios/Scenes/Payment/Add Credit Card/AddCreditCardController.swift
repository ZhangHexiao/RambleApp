//
//  AddCreditCardController.swift
//  ramble-ios
//  Copyright Ramble Technologies Inc. All rights reserved.
//

import UIKit
import Foundation

protocol addCardDelegate: class {
   func updateContent()
}

class AddCreditCardController: BaseController {
    
    @IBOutlet weak var cardNumberTextField: RMBTextField!
    @IBOutlet weak var cvvTextField: RMBTextField!
    @IBOutlet weak var expirationDateTextField: RMBTextField!
    @IBOutlet weak var holderNameTextField: RMBTextField!
    
    let viewModel: CardViewModel
    weak var delegate: addCardDelegate?
    
    public init(viewModel: CardViewModel, delegate: addCardDelegate) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  User.current()?.stpCustomerId == nil || User.current()?.stpCustomerId == ""{
            StripeService().createUserAccount(){ [weak self] (_, error) in
                if let err = error {
                    self?.didFail(error: err.localizedDescription, removeFromTop: false)
                    return
                }
                self?.didSuccess(msg: "".localized, removeFromTop: false)
            }
        }
        
        
        cardNumberTextField.delegate = self
        cvvTextField.delegate = self
        expirationDateTextField.delegate = self
        holderNameTextField.delegate = self
        
        viewModel.delegate = self
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()

    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationItem.title = "Credit Card".localized
        navigationItem.hidesBackButton = true
        
        let itemCancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = itemCancel
        
        let itemSave = UIBarButtonItem(title: "Save".localized, style: .plain, target: self, action: #selector(actionSave))
        navigationItem.rightBarButtonItem = itemSave
    }
    
    // MARK: Layout
    func loadLayout() {
        cardNumberTextField.placeholder = "Card number: 0000 0000 0000 0000".localized
        cvvTextField.placeholder = "CVV: 123".localized
        expirationDateTextField.placeholder = "Expiration date: MM/YY".localized
        holderNameTextField.placeholder = "Card holder name".localized
        
        if viewModel.hasCard {
            cardNumberTextField.text = viewModel.number
            cvvTextField.text = viewModel.ccv
            expirationDateTextField.text = viewModel.date
            holderNameTextField.text = viewModel.cardHolder
        }
    }
    
    func bind() {
        viewModel.numberChanged = { [weak self] number in
            self?.cardNumberTextField.text = number
        }
        
        viewModel.ccvChanged = { [weak self] ccv in
            self?.cvvTextField.text = ccv
        }
        
        viewModel.dateChanged = { [weak self] dateString in
            self?.expirationDateTextField.text = dateString
        }
        
        viewModel.cardHolderChanged = { [weak self] dateString in
            self?.holderNameTextField.text = dateString
        }
    }
    
    // MARK: - Actions
    @objc private func actionCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func actionSave() {
        showLoading()
        
        if viewModel.hasCard {
            viewModel.update()
        } else {
            viewModel.save()
        }
    }
}

// MARK: - CardViewModelDelegate
extension AddCreditCardController: CardViewModelDelegate {
    func didFail(error: String, removeFromTop: Bool) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
        
        if removeFromTop {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didSuccess(msg: String, removeFromTop: Bool) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
        
        if removeFromTop {
            self.delegate?.updateContent()
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddCreditCardController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == expirationDateTextField {
            return viewModel.shouldChangeDate(currentDate: textField.text ?? "", in: range, with: string)
        } else if textField == cardNumberTextField {
            return viewModel.shouldChangeCardNumber(currentNumber: textField.text ?? "", in: range, with: string)
        } else if textField == cvvTextField {
            return viewModel.shouldChangeCCV(currentCCV: textField.text ?? "", in: range, with: string)
        } else if textField == holderNameTextField {
            return viewModel.shouldChangeHolderName(currentHolderName: textField.text ?? "", in: range, with: string)
        }
        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//    if textField == expirationDateTextField {
//            textField.resignFirstResponder()
//            let expiryDatePicker = MonthYearPickerView()
//            view.addSubview(expiryDatePicker)
//            expiryDatePicker.translatesAutoresizingMaskIntoConstraints = false
//            expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
//                let string = String(format: "%02d/%d", month, year)
//                print(string)
//            }
//        }
//    }
}
