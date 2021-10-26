//
//  EventDetailsBottomView.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-22.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol EventDetailsBottomViewDelegate: class {
    func didTapInsterested()
    func didTapShare()
    func didTapTickets()
    func didTapContact()
}

class EventDetailsBottomView: UIView, NibLoadable {
    
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var interestedButton: UIButton!
    @IBOutlet weak var getTicketsButton: RMBButton!    
    @IBOutlet weak var contactBurtton: RMBButton!
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var getTicketsLeading: NSLayoutConstraint!
    @IBOutlet weak var shareButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var interestedButtonTrailingToCenter: NSLayoutConstraint!
    @IBOutlet weak var shareButtonLeadingToCenter: NSLayoutConstraint!
    
    weak var delegate: EventDetailsBottomViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    func configure(interestedIcon: UIImage, hasTickets: Bool) {
        backgroundColor = UIColor.AppColors.cardBackground.withAlphaComponent(0.5)
        shareLabel.text = "Share".localized
        interestedLabel.text = "Interested".localized
        getTicketsButton.setTitle("Get Tickets".localized, for: .normal)
        contactBurtton.setTitle("Contact".localized, for: .normal)
        getTicketsButton.titleEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        interestedButton.setImage(interestedIcon, for: .normal)
        interestedButton.isEnabled = true
        shareButton.setImage(#imageLiteral(resourceName: "ic_share"), for: .normal)
        
        loadLayout(hasTickets)
    }
}

// MARL: - Actions
extension EventDetailsBottomView {
    
    @IBAction func actionShare() {
        delegate?.didTapShare()
    }
    
    @IBAction func actionInterested() {
        delegate?.didTapInsterested()
    }
    
    @IBAction func actionGetTickets() {
        delegate?.didTapTickets()
    }
    
    @IBAction func contactHost(){
        delegate?.didTapContact()
    }
}

// MARK: - Private
extension EventDetailsBottomView {
    private func loadLayout(_ hasTickets: Bool) {
//        getTicketsLeading.isActive = hasTickets
//        shareButtonLeading.isActive = hasTickets       
//        interestedButtonTrailingToCenter.isActive = !hasTickets
//        shareButtonLeadingToCenter.isActive = !hasTickets
        
        getTicketsButton.isEnabled = hasTickets
        getTicketsButton.isHidden = !hasTickets
        
        layoutSubviews()
    }
}
