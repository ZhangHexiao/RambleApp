//
//  TextFieldCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-06.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    func didTapBuTextFieldCellButton()
}

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint! // 32
    
    weak var delegate: TextFieldCellDelegate?
    
    func configure(with placeHolder: String, buttonTitle: String? = nil, buttonIcon: UIImage? = nil) {
        
        placeHolderLayout(placeHolder: placeHolder)
        
        button.setTitle(buttonTitle, for: .normal)
        button.setImage(buttonIcon, for: .normal)
        
        if buttonTitle != nil || buttonIcon != nil {
            buttonWidth.constant = TextFieldCell.kButtonWidth
        } else {
            buttonWidth.constant = 0
        }
        
        layoutIfNeeded()
    }
    
    @IBAction func actionButton() {
        delegate?.didTapBuTextFieldCellButton()
    }
    
}

extension TextFieldCell {
    private func placeHolderLayout(placeHolder: String) {
        // Set place holder layout
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.AppColors.placeHolderGray,
                          .font: Fonts.Futura.medium.size(16)]
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: attributes)
    }
}

extension TextFieldCell {
    private static var kButtonWidth: CGFloat { return 32 }
}
