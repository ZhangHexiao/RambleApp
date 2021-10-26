//
//  ButtonSection.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonSectionDelegate: class {
    func didTapAction()
    func didTapLabel()
}

class ButtonSection: UIView {
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var buttonAction: UIButton!
    
    @IBOutlet weak var filterIcon: UIImageView!
    
    weak var delegate: ButtonSectionDelegate?
    
    func configure(with title: String, buttonTitle: String? = nil, downArrow: Bool = false, buttonHide:Bool = true, delegate: ButtonSectionDelegate?) {
        
        if downArrow == true{
            let attachment = NSTextAttachment()
            attachment.bounds = CGRect(x:10, y: -4, width: 25, height: 25)
            let downArrow: UIImage = #imageLiteral(resourceName: "downArrow80*80")
            attachment.image = downArrow
            let attachmentString = NSAttributedString(attachment: attachment)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.HelveticaNeue.bold.size(34),
                .foregroundColor: UIColor.AppColors.cityButton
            ]
            let myString = NSMutableAttributedString(string:title + "", attributes: attributes)
            myString.addAttribute(NSAttributedString.Key.kern, value: -2.0, range: NSRange(location: 0, length: myString.length - 1))
            myString.append(attachmentString)
            contentLabel.attributedText = myString
            
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.HelveticaNeue.bold.size(34),
                .foregroundColor: UIColor.AppColors.cityButton
            ]
            let myString = NSMutableAttributedString(string:title + "", attributes: attributes)
            myString.addAttribute(NSAttributedString.Key.kern, value: -2.0, range: NSRange(location: 0, length: myString.length - 1))
            contentLabel.attributedText = myString
        }
        
        filterIcon.isHidden = buttonHide
        
        if let buttonTitle = buttonTitle {
            buttonAction.isHidden = false
            buttonAction.setTitle(buttonTitle, for: .normal)
        } else {
            buttonAction.isHidden = true
        }
        
        self.delegate = delegate
    }
    
    func setupLabelTap(){
        let lableTap = UITapGestureRecognizer(target:self,action:#selector(self.LabelTapped(_ :)))
        self.contentLabel.isUserInteractionEnabled = true
        self.contentLabel.addGestureRecognizer(lableTap)
    }
    
    @IBAction func actionButton() {
        delegate?.didTapAction()
    }
    
    @objc func LabelTapped(_ sender:UITapGestureRecognizer){
        delegate?.didTapLabel()
    }
}

extension ButtonSection {
    class func fromNib() -> ButtonSection {
        let nib = UINib(nibName: "ButtonSection", bundle: Bundle.main)
        // swiftlint:disable:next force_cast
        return nib.instantiate(withOwner: self, options: nil)[0] as! ButtonSection
    }
}

extension ButtonSection {
    static var kHeight: CGFloat { return 40 }
}
