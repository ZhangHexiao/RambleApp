//
//  ExpandingTextViewCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-08-30.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

enum ExpandingFieldType: Int {
    case title, description, weblink, indicativePrice, nbAvailableTickets, none
    
    func placeHolder() -> String {
        switch self {
        case .title: return "Event name".localized
        case .description: return "Description".localized
        case .weblink: return "Web link".localized
        case .nbAvailableTickets: return "Number of available tickets (optional)".localized
        case .indicativePrice: return "Indicative price for tickets (optional)".localized
        case .none: return ""
        }
    }
}

protocol TextViewCellDelegate: class {
    func didUpdate(height: CGFloat, for type: ExpandingFieldType)
    func didTapCellButton()
    func didEndEditing(text: String, for type: ExpandingFieldType)

}

class ExpandingTextViewCell: UITableViewCell {
    
    weak var delegate: TextViewCellDelegate?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint! // 32
    
    var expandingFieldType: ExpandingFieldType = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.tintColor = .white
    }
    
    // swiftlint:disable:next line_length
    func configure( placeHolder: String, content: String?, type: ExpandingFieldType, delegate: TextViewCellDelegate? = nil, buttonTitle: String? = nil, buttonIcon: UIImage? = nil) {
        
        self.delegate = delegate
        
        textView.text = content == nil ? placeHolder : content
        textView.textColor = content == nil ? UIColor.AppColors.placeHolderGray : .white
        
        expandingFieldType = type
        
        if buttonTitle != nil || buttonIcon != nil {
            buttonWidth.constant = ExpandingTextViewCell.kButtonWidth
            button.setTitle(buttonTitle, for: .normal)
            button.setImage(buttonIcon, for: .normal)
        } else {
            buttonWidth.constant = 0
        }
        
        switch expandingFieldType {
        case .title, .description:
            textView.keyboardType = .default
            textView.autocapitalizationType = .sentences
        case .weblink:
            textView.keyboardType = .URL
            textView.autocapitalizationType = .none
        case .nbAvailableTickets:
            textView.keyboardType = .numberPad
        case .indicativePrice:
            textView.keyboardType = .decimalPad
        case .none: break
        }
        
        layoutIfNeeded()
    }
    
    @IBAction func actionButton() {
        delegate?.didTapCellButton()
    }
}

// MARK: - UITextViewDelegate
extension ExpandingTextViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if expandingFieldType != .indicativePrice { return true }
        
        // We don't allow to add multiple points after added a decimal
        let existingTextHasDecimalSeparator = textView.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = text.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.newHeight(withBaseHeight: ExpandingTextViewCell.kBaseHeight)
        delegate?.didUpdate(height: height, for: expandingFieldType)
        if expandingFieldType != .indicativePrice { return }
        
        textView.text = textView.text.currencyInputFormatting()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == expandingFieldType.placeHolder() {
            textView.text = ""
            textView.textColor = UIColor.white
            return
        }
        
        if expandingFieldType == .nbAvailableTickets {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = expandingFieldType.placeHolder()
            textView.textColor = UIColor.AppColors.placeHolderGray
        } else {
            delegate?.didEndEditing(text: textView.text, for: expandingFieldType)
        }
    }
}

extension ExpandingTextViewCell {
    private static var kButtonWidth: CGFloat { return 32 }
    static var kBaseHeight: CGFloat { return 61 }
}
