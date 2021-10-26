//
//  IconTextButtonSection.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-26.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol SectionDelegate: class {
    func didTapAction(for section: SectionType)
}

class IconTextButtonSection: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var buttonAction: UIButton!

    weak var delegate: SectionDelegate?
    var sectionType: SectionType = .none
    
    func configure(with icon: UIImage, title: String, buttonTitle: String, delegate: SectionDelegate?) {
        contentLabel.text = title
        iconImageView.image = icon
        buttonAction.setTitle(buttonTitle, for: .normal)
        self.delegate = delegate
    }
    
    func configure(with buttonTitle: String, type: SectionType, delegate: SectionDelegate?) {
        sectionType = type
        contentLabel.text = type.localized
        iconImageView.image = type.icon()
        buttonAction.setTitle(buttonTitle, for: .normal)
        self.delegate = delegate
    }
    
    @IBAction func actionButton() {
        delegate?.didTapAction(for: sectionType)
    }
}

extension IconTextButtonSection {
    class func fromNib() -> IconTextButtonSection {
        let nib = UINib(nibName: "IconTextButtonSection", bundle: Bundle.main)
        // swiftlint:disable:next force_cast
        return nib.instantiate(withOwner: self, options: nil)[0] as! IconTextButtonSection
    }
}

extension IconTextButtonSection {
    static var kHeight: CGFloat { return 32 }
}

enum SectionType: String {
    case interested = "Interested", created = "Created", myTickets = "My tickets", none
    
    func icon() -> UIImage {
        switch self {
        case .interested: return #imageLiteral(resourceName: "ic_star_small")
        case .myTickets: return #imageLiteral(resourceName: "ic_ticket")
        case .created: return #imageLiteral(resourceName: "ic_add_small")
        default: return UIImage()
        }
    }
    
    var localized: String {
        switch self {
        case .interested: return "Interested".localized
        case .myTickets: return "My tickets".localized
        case .created: return "Created".localized
        case .none:
            return ""
        }
    }
}
