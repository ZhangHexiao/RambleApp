//
//  HomeEventCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class HomeEventCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var ownerImageView: RMBRoundImage!
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var badgeImageView: UIImageView!
    
    func configure(with viewModel: EventViewModel?) {
        
        let now = Date()
        let start = viewModel?.event.startAt ?? Date()
        let end = viewModel?.event.endAt ?? Date()
        if (start...end).contains(now) {
            var dateComponents = DateComponents()
            dateComponents.year = now.year
            dateComponents.month = now.month
            dateComponents.day = now.day
            dateComponents.hour = start.hour
            dateComponents.minute = start.mins
            let userCalendar = Calendar.current
            let displayDate = userCalendar.date(from: dateComponents)
            eventDateLabel.text =  RMBDateFormat.fullFormat.formatted(date: displayDate).capitalizingFirstLetter()
        } else {
            eventDateLabel.text = viewModel?.homeDateFormatted
        }
        
        eventTitleLabel.text = viewModel?.eventName
        
        // Name last name
        ownerLabel.text = viewModel?.ownerName
        
        badgeImageView.isHidden = !(viewModel?.ownerIsVerified ?? false)

        self.eventImageView.image = nil
        viewModel?.loadCoverImage { [weak self] (image) in
            self?.eventImageView.image = image
        }
        
        viewModel?.loadOwnerImage { [weak self] (image) in
            self?.ownerImageView.image = image ?? #imageLiteral(resourceName: "ic_user_tab")
        }
    }
}

extension HomeEventCell {
    static var kHeight: CGFloat { return 340.0 }
}
