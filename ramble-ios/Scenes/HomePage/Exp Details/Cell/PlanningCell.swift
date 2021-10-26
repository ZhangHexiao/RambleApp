//
//  PlanningCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-11.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class PlanningCell: UITableViewCell {

    @IBOutlet weak var planContent: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

  func configure(with viewModel: EventViewModel) {
//        durationImage.image = viewModel.ownerImage ?? #imageLiteral(resourceName: "ic_user_tab_selected")
    }
    
}
