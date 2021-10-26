//
//  RMBTextField.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-30.
//  Created by HexiaoZhang Ramble Technologies Inc. on 2020-08-08.
//

import UIKit
import JVFloatLabeledTextField

class RMBTextField: JVFloatLabeledTextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        leftView = padding
        rightView = padding
        leftViewMode = .always
        rightViewMode = .always

        layer.cornerRadius = 16

        placeholderYPadding = 0
        floatingLabelYPadding = 10
        tintColor = .white
        font = Fonts.Futura.medium.size(16)
        textColor = UIColor.AppColors.textGray
        placeholderColor = UIColor.AppColors.placeHolderGray
        floatingLabelFont = Fonts.Futura.medium.size(14)
        floatingLabelTextColor = UIColor.AppColors.placeHolderGray
        floatingLabelActiveTextColor = UIColor.AppColors.placeHolderGray
        
        backgroundColor = UIColor.AppColors.cardBackground.withAlphaComponent(0.5)
    }
}
