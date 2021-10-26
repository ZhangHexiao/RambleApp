//
//  SelectEventCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SelectEventCell: UITableViewCell {

    @IBOutlet weak var eventView: EventView!
    @IBOutlet weak var selectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with eventViewModel: EventViewModel?) {
        guard let eventViewModel = eventViewModel else { return }
        eventView.configure(with: eventViewModel)
        
        if eventViewModel.isSelected {
            selectView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        } else {
            selectView.backgroundColor = UIColor.clear
        }
    }
    
}

extension SelectEventCell {
    static var kHeight: CGFloat { return 110.0 }
}
