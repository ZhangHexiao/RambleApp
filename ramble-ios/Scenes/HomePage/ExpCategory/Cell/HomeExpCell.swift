//
//  HomeEventCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol HomeExpCellDelegate: class{
    func afterTapLike(indexPath: IndexPath)
    func updateOneRow(indexPath: IndexPath)
}

class HomeExpCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var badgeImageView: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var interestButton: UIButton!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var perPerson: UILabel!
    
    var viewModel: EventViewModel?
    var viewDetailModel: ExpDetailViewModel?
    var indexPath: IndexPath?
    weak var delegate: HomeExpCellDelegate?
    weak var searchDelegate: SearcheventDataSourceDelegate?
    
    var interestedIcon: UIImage {
        if viewModel!.hasBoughtTickets {
            return #imageLiteral(resourceName: "ic_interest")
        }
        return viewModel!.hasBeenInterested ? #imageLiteral(resourceName: "ic_interest") : #imageLiteral(resourceName: "ic_like")
    }
    
    func configure(with viewDetailModel: ExpDetailViewModel?, delegate: HomeExpCellDelegate? = nil, searchDelegate: SearcheventDataSourceDelegate? = nil, indexPath: IndexPath) {
        
        if User.current() == nil {
            interestButton.isHidden = true
        }
        self.delegate = delegate
        self.searchDelegate = searchDelegate
        self.viewDetailModel = viewDetailModel
//        self.viewDetailModel = ExpDetailViewModel(event: self.viewModel!.event)
        self.viewModel = viewDetailModel?.eventViewModel
        self.indexPath = indexPath
        eventImageView.roundCorner(with: 40, to:  [.topLeft, .topRight])
        bottomView.roundCorner(with: 40, to: [.bottomLeft, .bottomRight])
        
//        let now = Date()
        let start = viewModel?.event.startAt ?? Date()
//        let end = viewModel?.event.endAt ?? Date()
//        if (start...end).contains(now) {
//            var dateComponents = DateComponents()
//            dateComponents.year = now.year
//            dateComponents.month = now.month
//            dateComponents.day = now.day
//            dateComponents.hour = start.hour
//            dateComponents.minute = start.mins
//            let userCalendar = Calendar.current
//            let displayDate = userCalendar.date(from: dateComponents)
//            eventDateLabel.text =  RMBDateFormat.fullFormat.formatted(date: displayDate).capitalizingFirstLetter()
//        } else {
//            eventDateLabel.text = viewModel?.homeDateFormatted
//        }
         eventDateLabel.text = RMBDateFormat.monthDay.formatted(date: start).capitalizingFirstLetter()
        price.text = viewDetailModel?.eventViewModel.minPrice
        if price.text == "Free" {
            perPerson.text = " to Join Now!"
        }
        
        eventTitleLabel.text = viewModel?.eventName
        ownerLabel.text = viewModel?.averageStar
        interestButton.tag = indexPath.row
        
        interestButton.setImage(viewDetailModel?.interestedIcon, for: .normal)
        
        self.eventImageView.image = nil
        viewModel?.loadCoverImage { [weak self] (image) in
            self?.eventImageView.image = image
        }
        
    }
    
    @IBAction func tapInterest(_ sender: Any) {
        delegate?.afterTapLike(indexPath: self.indexPath!)
    }
}

extension HomeExpCell {
    static var kHeight: CGFloat { return 380.0 }
}
