//
//  EventCollectionViewCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-01.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    @IBOutlet weak var eventCoverImage: UIImageView!
    
    @IBOutlet weak var buttomView: UIView!
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var Price: UILabel!
    
    @IBOutlet weak var priceNumber: UILabel!
    
    @IBOutlet weak var dollarSign: UILabel!
    
    func configure(with viewModel: EventViewModel?) {
        eventCoverImage.roundCorner(with: 30, to:  [.topLeft, .topRight])
        buttomView.roundCorner(with: 15, to: [.bottomLeft, .bottomRight])
        Title.text = viewModel?.eventName
//        Price.text = viewModel?.rangePrice
        if viewModel?.minPrice == "Free" {
          priceNumber.isHidden = true
          dollarSign.isHidden = true
          Price.font = Fonts.HelveticaNeue.medium.size(15)
          Price.text = "Free"
        } else {
            priceNumber.isHidden = false
            dollarSign.isHidden = false
            priceNumber.text = viewModel!.minPrice
        }
        self.eventCoverImage.image = nil
        viewModel?.loadCoverImage { [weak self] (image) in
            self?.eventCoverImage.image = image
        }
    }   
}
extension EventCollectionViewCell {
    static var kHeight: CGFloat { return 180.0 }
}
