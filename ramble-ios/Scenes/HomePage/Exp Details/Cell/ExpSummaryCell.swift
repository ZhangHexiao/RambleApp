//
//  ExpSummaryCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-11.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class ExpSummaryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var durationImage: UIImageView!
    
    func configure(with viewModel: EventViewModel) {
//        durationImage.image = viewModel.ownerImage ?? #imageLiteral(resourceName: "ic_user_tab_selected")
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
extension ExpSummaryCell {
    static var kHeight: CGFloat { return 95.0 }
}

