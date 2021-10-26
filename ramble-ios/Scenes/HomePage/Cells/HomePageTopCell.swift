//
//  HomePageTopCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-05-31.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class HomePageTopCell: UICollectionViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceNumber: UILabel!
    @IBOutlet weak var perPerson: UILabel!
    
    
    func configure(with viewModel: EventViewModel?) {
        
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
////            let userCalendar = Calendar.current
////            let displayDate = userCalendar.date(from: dateComponents)
//            startTime.text = "OFFERED TODAY"
////            startTime.text =  RMBDateFormat.fullFormat.formatted(date: displayDate).capitalizingFirstLetter()
//        } else {
            startTime.text = RMBDateFormat.monthDay.formatted(date: start).capitalizingFirstLetter()
//        }
        
        title.text = viewModel?.eventName
        title.addCharacterSpacing(kernValue: -1.5)
        
        if viewModel?.minPrice == "Free" {
          perPerson.isHidden = true
          price.isHidden = true
          priceNumber.text = "Free to join NOW!"
        } else {
            perPerson.isHidden = false
            price.isHidden = false
            priceNumber.text = viewModel!.minPrice
        }

        self.topImage.image = nil
        viewModel?.loadCoverImage { [weak self] (image) in
            self?.topImage.image = image
        }
    }
    
    func configure(with viewModel: ExpDetailViewModel?) {
        startTime.text = "Montreal, Canada"
        startTime.text = viewModel?.expCity ?? "Montreal," + " Canada"
        title.text = viewModel?.eventViewModel.eventName
        title.addCharacterSpacing(kernValue: -1.5)
        
        
        if viewModel?.eventViewModel.minPrice == "Free" {
          perPerson.isHidden = true
          price.isHidden = true
          priceNumber.text = "Free to join NOW!"
        } else {
            perPerson.isHidden = false
            price.isHidden = false
            priceNumber.text = viewModel?.eventViewModel.minPrice
        }

        self.topImage.image = nil
        viewModel?.eventViewModel.loadCoverImage { [weak self] (image) in
            self?.topImage.image = image
        }
    }
    
}

extension HomePageTopCell {
    static var kHeight: CGFloat { return 350.0 }
}

