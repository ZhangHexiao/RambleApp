//
//  NewEventCellImage.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class NewEventCellImage: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
   
    weak var delegate: TextViewCellDelegate?
    var expandingFieldType: ExpandingFieldType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        eventImageView.cornerRadius = 16
        textView.delegate = self
        textView.tintColor = .white
    }
    
    func configure(with image: UIImage, placeHolder: String, content: String?, type: ExpandingFieldType, delegate: TextViewCellDelegate? = nil) {
        self.delegate = delegate
        expandingFieldType = type
        eventImageView.image = image

        textView.text = content == nil ? placeHolder : content
        textView.textColor = content == nil ? UIColor.AppColors.placeHolderGray : .white
    }
    
    @IBAction func actionButton() {
        delegate?.didTapCellButton()
    }
}

extension NewEventCellImage: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.newHeight(withBaseHeight: 61)
        delegate?.didUpdate(height: height, for: expandingFieldType)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == expandingFieldType.placeHolder() {
            textView.text = ""
            textView.textColor = UIColor.white
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

extension NewEventCellImage {
    static var kBaseHeight: CGFloat { return 220 }
}
