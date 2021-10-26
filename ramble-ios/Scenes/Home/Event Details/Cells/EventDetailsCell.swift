//
//  EventDetailsCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol EventDetailsSelectOutsideTicketsDelegate: class {
    func didSelectOutsideTickets()
}

protocol EventDetailsSelectLocationDelegate: class {
    func didSelectLocation()
}

class EventDetailsCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ticketsAvailableButton: UIButton!
    @IBOutlet weak var ticketsRangePriceLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var eventDetailsSelectLocationDelegate: EventDetailsSelectLocationDelegate?
    weak var eventDetailsSelectOutsideTicketsDelegate: EventDetailsSelectOutsideTicketsDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        ticketsAvailableButton.titleLabel?.numberOfLines = 0
        locationButton.titleLabel?.numberOfLines = 0
    }
    
    // swiftlint:disable:next line_length
    func configure(with viewModel: EventViewModel, eventDetailsSelectLocationDelegate: EventDetailsSelectLocationDelegate?, eventDetailsSelectOutsideTicketsDelegate: EventDetailsSelectOutsideTicketsDelegate?) {
        
        self.eventDetailsSelectLocationDelegate = eventDetailsSelectLocationDelegate
        self.eventDetailsSelectOutsideTicketsDelegate = eventDetailsSelectOutsideTicketsDelegate
        
        dateLabel.text = viewModel.dateFormatted
        ticketsRangePriceLabel.text = viewModel.rangePrice
        descriptionLabel.text = viewModel.description
        locationButton.setTitle(viewModel.location, for: .normal)

        if !viewModel.isTicketsAvailable {
            
            if viewModel.ticketsWebLinkString != nil {
                ticketsAvailableButton.setTitleColor(.white, for: .normal)
                ticketsAvailableButton.setTitle("Website".localized, for: .normal)
            } else {
                ticketsAvailableButton.setTitle("No tickets for sale".localized, for: .normal)
                ticketsAvailableButton.setTitleColor(UIColor.AppColors.unselectedTextGray, for: .normal)
            }
        } else {
            ticketsAvailableButton.setTitle(viewModel.ticketsAvailable, for: .normal)
            ticketsAvailableButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func actionLocation() {
        eventDetailsSelectLocationDelegate?.didSelectLocation()
    }
    
    @IBAction func actionTickets() {
       eventDetailsSelectOutsideTicketsDelegate?.didSelectOutsideTickets()
    }
}
